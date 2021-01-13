// pxcview36_sample_app.cpp : Defines the entry point for the application.
//

#include "stdafx.h"
#include "PDFXEditSimple_app.h"
#include "PDFXEditSimple.h"
//#include "pxcview36_errors.h"
#include <Commdlg.h>
#include <commctrl.h>

#define MAX_LOADSTRING 100
#define PS40_ERR_DocEncrypted 100

// Global Variables:
HINSTANCE hInst;								// current instance
WCHAR szTitle[MAX_LOADSTRING];					// The title bar text
WCHAR szMainWindowClass[MAX_LOADSTRING];		// the main window class name
WCHAR szChildWindowClass[MAX_LOADSTRING];		// the child window class name

LONG pixPageWidth = -1;
LONG pixPageHeigth = -1;

LONG curXpos = 0;
LONG curYpos = 0;
LONG xDPI = 0;
LONG yDPI = 0;

DWORD curPage = 0;
DWORD pagesCount = 0;
double zoom = 100; // zom factor in percents
PXVDocument curDoc = nullptr;
RECT borders = {5, 5, 5, 5};

HWND hStatusBar = nullptr;
HWND hMain = nullptr;
HWND hView = nullptr;

CHAR password[256];
DWORD pass_len = 0;


void mSetScrollInfo(HWND mWnd, BOOL bKeepPos = TRUE)
{
	RECT rcClient;
	if (!::GetClientRect(mWnd, &rcClient))
		return;
	const LONG clientWidth = rcClient.right - rcClient.left;
	const LONG clientHeight = rcClient.bottom - rcClient.top;
	borders.left = 5;
	borders.top = 5;
	borders.right = 5;
	borders.bottom = 5;
	if (clientWidth > borders.left + borders.right + pixPageWidth)
	{
		borders.left = (clientWidth - pixPageWidth) / 2;
		borders.right = clientWidth - pixPageWidth - borders.left;
	}
	if (clientHeight > borders.top + borders.bottom + pixPageHeigth)
	{
		borders.top = (clientHeight - pixPageHeigth) / 2;
		borders.bottom = clientHeight - pixPageHeigth - borders.top;
	}
	SCROLLINFO si;
	si.cbSize = sizeof(si);
	si.fMask = SIF_ALL;
	if (bKeepPos)
	{
		::GetScrollInfo(mWnd, SB_HORZ, &si);
	}
	else
	{
		si.nMin = 0;
		si.nPos = 0;
	}
	si.nMax = pixPageWidth + borders.left + borders.right;
	if ((pixPageWidth <= 0) || (pixPageHeigth <= 0) || (si.nMax <= clientWidth))
	{
		si.nMax = 1;
		si.nPage = 1;
		::EnableScrollBar(mWnd, SB_HORZ, ESB_DISABLE_BOTH);
		curXpos = 0;
	}
	else
	{
		si.nPage = clientWidth;
		::SetScrollInfo(mWnd, SB_HORZ, &si, TRUE);
		::GetScrollInfo(mWnd, SB_HORZ, &si);
		curXpos = si.nPos;
		::EnableScrollBar(mWnd, SB_HORZ, ESB_ENABLE_BOTH);
	}
	if (bKeepPos)
	{
		::GetScrollInfo(mWnd, SB_VERT, &si);
	}
	else
	{
		si.nMin = 0;
		si.nPos = 0;
	}
	si.nMax = pixPageHeigth + borders.top + borders.bottom;
	if ((pixPageWidth <= 0) || (pixPageHeigth <= 0) || (si.nMax <= clientHeight))
	{
		si.nMax = 1;
		si.nPage = 1;
		::EnableScrollBar(mWnd, SB_VERT, ESB_DISABLE_BOTH);
		curYpos = 0;
	}
	else
	{
		si.nPage = clientHeight;
		::SetScrollInfo(mWnd, SB_VERT, &si, TRUE);
		::GetScrollInfo(mWnd, SB_VERT, &si);
		curYpos = si.nPos;
		::EnableScrollBar(mWnd, SB_VERT, ESB_ENABLE_BOTH);
	}
}


void DrawRect(HDC dc, const RECT& draw_rect, const RECT rcClient)
{
	RECT rect;
	if (!::IntersectRect(&rect, &draw_rect, &rcClient))
		return;
	HBRUSH margin = (HBRUSH)::GetStockObject(GRAY_BRUSH);
	HBRUSH page_background = (HBRUSH)::GetStockObject(WHITE_BRUSH);
	HBRUSH page_border = (HBRUSH)::GetStockObject(BLACK_BRUSH);
	if ((pixPageWidth <= 0) || (pixPageHeigth < 0))
	{
		::FillRect(dc, &rect, margin);
		return;
	}
	RECT rc;
	RECT fr;
	// Draw top border;
	rc.left = rcClient.left - curXpos;
	rc.top = rcClient.top - curYpos;
	rc.right = rc.left + pixPageWidth + borders.left + borders.right;
	rc.bottom = rc.top + borders.top - 1;
	if (::IntersectRect(&fr, &rc, &rect))
		::FillRect(dc, &fr, margin);
	rc.left = rcClient.left - curXpos + borders.left;
	rc.top = rcClient.top - curYpos + borders.top - 1;
	rc.right = rc.left + pixPageWidth;
	rc.bottom = rc.top + 1;
	if (::IntersectRect(&fr, &rc, &rect))
		::FillRect(dc, &fr, page_border);
	// Draw left border
	rc.left = rcClient.left - curXpos;
	rc.top = rcClient.top - curYpos + borders.top - 1;
	rc.right = rc.left + borders.left - 1;
	rc.bottom = rc.top + pixPageHeigth + 2;
	if (::IntersectRect(&fr, &rc, &rect))
		::FillRect(dc, &fr, margin);
	rc.left = rcClient.left - curXpos + borders.left - 1;
	rc.top = rcClient.top - curYpos + borders.top - 1;
	rc.right = rc.left + 1;
	rc.bottom = rc.top + pixPageHeigth + 2;
	if (::IntersectRect(&fr, &rc, &rect))
		::FillRect(dc, &fr, page_border);
	// Draw right border
	rc.left = rcClient.left - curXpos + borders.left + pixPageWidth + 1;
	rc.top = rcClient.top - curYpos + borders.top - 1;
	rc.right = rc.left + borders.right - 1;
	rc.bottom = rc.top + pixPageHeigth + 2;
	if (::IntersectRect(&fr, &rc, &rect))
		::FillRect(dc, &fr, margin);
	rc.left = rcClient.left - curXpos + borders.left + pixPageWidth;
	rc.top = rcClient.top - curYpos + borders.top - 1;
	rc.right = rc.left + 1;
	rc.bottom = rc.top + pixPageHeigth + 2;
	if (::IntersectRect(&fr, &rc, &rect))
		::FillRect(dc, &fr, page_border);
	// Draw bottom border;
	rc.left = rcClient.left - curXpos;
	rc.top = rcClient.top - curYpos + borders.top + pixPageHeigth + 1;
	rc.right = rc.left + pixPageWidth + borders.left + borders.right;
	rc.bottom = rc.top + borders.bottom - 1;
	if (::IntersectRect(&fr, &rc, &rect))
		::FillRect(dc, &fr, margin);
	rc.left = rcClient.left - curXpos + borders.left;
	rc.top = rcClient.top - curYpos + borders.top + pixPageHeigth;
	rc.right = rc.left + pixPageWidth;
	rc.bottom = rc.top + 1;
	if (::IntersectRect(&fr, &rc, &rect))
		::FillRect(dc, &fr, page_border);
	// Draw page
	rc.left = rcClient.left - curXpos + borders.left;
	rc.top = rcClient.top - curYpos + borders.top;
	rc.right = rc.left + pixPageWidth;
	rc.bottom = rc.top + pixPageHeigth;
	if (::IntersectRect(&fr, &rc, &rect))
	{
		::FillRect(dc, &fr, page_background);
		PXV_CommonRenderParameters dp;
		dp.WholePageRect = &rc;
		dp.DrawRect = &fr;
		dp.Flags = 0;
		dp.RenderTarget = pxvrm_Viewing;
		PXCV_DrawPageToDC(curDoc, curPage, dc, &dp);
	}
}

void doPaint(HWND hWnd)
{
	PAINTSTRUCT ps;
	HDC dc;
	RECT rcClient;
	if (!::GetClientRect(hWnd, &rcClient))
		return;

	RGNDATA *pRgnData = nullptr;
	do
	{
		RECT rcUpdate = {0,0,0,0};
		::GetUpdateRect(hWnd, &rcUpdate, FALSE);
		HRGN hRgnUpdate = ::CreateRectRgnIndirect(&rcUpdate);
		int nReg = ::GetUpdateRgn(hWnd, hRgnUpdate, FALSE);
		if (nReg == COMPLEXREGION)
		{
			DWORD cbRgnData = ::GetRegionData(hRgnUpdate, 0, nullptr);
			if (cbRgnData == 0)
				break;
			pRgnData = (RGNDATA*)new BYTE[cbRgnData];
			::GetRegionData(hRgnUpdate, cbRgnData, pRgnData);
		}
		::DeleteObject(hRgnUpdate);
		if (nReg == ERROR)
			break;
		dc = BeginPaint(hWnd, &ps);
		if (pRgnData && pRgnData->rdh.nCount)
		{
			RECT* rects = (RECT*)pRgnData->Buffer;
			for (DWORD i = 0; i < pRgnData->rdh.nCount; i++)
			{
				DrawRect(dc, rects[i], rcClient);
			}
		}
		else
		{
			if (::IsRectEmpty(&rcUpdate))
				rcUpdate = rcClient;
			else
				::IntersectRect(&rcUpdate, &rcClient, &rcUpdate);
			DrawRect(dc, rcUpdate, rcClient);
		}
		EndPaint(hWnd, &ps);
	}
	while(false);
	if (pRgnData != nullptr)
		delete[] pRgnData;
}

BOOL ChangeZoom(int wmId);
BOOL ChangePage(int wmId);
BOOL OpenPdfFile(HWND hWnd);
BOOL ClosePdfFile();
void PrintPdfFile(HWND hParentWnd);


// Forward declarations of functions included in this code module:
ATOM				RegisterMainClass(HINSTANCE hInstance);
ATOM				RegisterChildClass(HINSTANCE hInstance);
BOOL				InitInstance(HINSTANCE, int);
LRESULT CALLBACK	MainWndProc(HWND, UINT, WPARAM, LPARAM);
LRESULT CALLBACK	ChildWndProc(HWND, UINT, WPARAM, LPARAM);
int CALLBACK		PasswordDlg(HWND, UINT, WPARAM, LPARAM);

int APIENTRY _tWinMain(HINSTANCE hInstance,
					 HINSTANCE hPrevInstance,
					 LPTSTR    lpCmdLine,
					 int       nCmdShow)
{
	UNREFERENCED_PARAMETER(hPrevInstance);
	UNREFERENCED_PARAMETER(lpCmdLine);

	InitCommonControls();
	//
	MSG msg;
	HACCEL hAccelTable;

	// Initialize global strings
	LoadStringW(hInstance, IDS_APP_TITLE, szTitle, MAX_LOADSTRING);
	LoadStringW(hInstance, IDC_PXCVIEW36_SAMPLE_APP, szMainWindowClass, MAX_LOADSTRING);
	LoadStringW(hInstance, IDC_PXCVIEW36_SAMPLE_APP_CHILD, szChildWindowClass, MAX_LOADSTRING);
	RegisterMainClass(hInstance);
	RegisterChildClass(hInstance);

	// Perform application initialization:
	if (!InitInstance (hInstance, nCmdShow))
	{
		return FALSE;
	}

	hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_PXCVIEW36_SAMPLE_APP));

	// Main message loop:
	while (GetMessage(&msg, nullptr, 0, 0))
	{
		if (!TranslateAccelerator(msg.hwnd, hAccelTable, &msg))
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
	}
	ClosePdfFile();
	return (int) msg.wParam;
}



//
//  FUNCTION: MyRegisterClass()
//
//  PURPOSE: Registers the window class.
//
//  COMMENTS:
//
//    This function and its usage are only necessary if you want this code
//    to be compatible with Win32 systems prior to the 'RegisterClassEx'
//    function that was added to Windows 95. It is important to call this function
//    so that the application will get 'well formed' small icons associated
//    with it.
//
ATOM RegisterMainClass(HINSTANCE hInstance)
{
	WNDCLASSEXW wcex;

	wcex.cbSize = sizeof(WNDCLASSEXW);

	wcex.style			= CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc	= MainWndProc;
	wcex.cbClsExtra		= 0;
	wcex.cbWndExtra		= 0;
	wcex.hInstance		= hInstance;
	wcex.hIcon			= LoadIconW(hInstance, MAKEINTRESOURCEW(IDI_PXCVIEW36_SAMPLE_APP));
	wcex.hCursor		= LoadCursor(nullptr, IDC_ARROW);
	wcex.hbrBackground	= (HBRUSH)(COLOR_WINDOW+1);
	wcex.lpszMenuName	= MAKEINTRESOURCEW(IDC_PXCVIEW36_SAMPLE_APP);
	wcex.lpszClassName	= szMainWindowClass;
	wcex.hIconSm		= LoadIconW(wcex.hInstance, MAKEINTRESOURCEW(IDI_SMALL));

	return RegisterClassExW(&wcex);
}

ATOM RegisterChildClass(HINSTANCE hInstance)
{
	WNDCLASSEXW wcex;

	wcex.cbSize = sizeof(WNDCLASSEXW);

	wcex.style			= CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc	= ChildWndProc;
	wcex.cbClsExtra		= 0;
	wcex.cbWndExtra		= 0;
	wcex.hInstance		= hInstance;
	wcex.hIcon			= LoadIconW(hInstance, MAKEINTRESOURCEW(IDI_PXCVIEW36_SAMPLE_APP));
	wcex.hCursor		= LoadCursor(nullptr, IDC_ARROW);
	wcex.hbrBackground	= (HBRUSH)(COLOR_WINDOW+1);
	wcex.lpszMenuName	= nullptr;
	wcex.lpszClassName	= szChildWindowClass;
	wcex.hIconSm		= nullptr;

	return RegisterClassExW(&wcex);
}

//
//   FUNCTION: InitInstance(HINSTANCE, int)
//
//   PURPOSE: Saves instance handle and creates main window
//
//   COMMENTS:
//
//        In this function, we save the instance handle in a global variable and
//        create and display the main program window.
//
BOOL InitInstance(HINSTANCE hInstance, int nCmdShow)
{
	hInst = hInstance; // Store instance handle in our global variable
	hMain = CreateWindowExW(0, szMainWindowClass, szTitle, WS_OVERLAPPEDWINDOW,
		CW_USEDEFAULT, 0, CW_USEDEFAULT, 0, nullptr, nullptr, hInstance, nullptr);

	if (!hMain)
	{
		return FALSE;
	}
	//
	hStatusBar = CreateStatusWindowW(WS_CHILD | WS_VISIBLE | CCS_BOTTOM,
		L"Ready", hMain, 0);
	hView = CreateWindowExW(0, szChildWindowClass, szTitle, WS_CHILD | WS_VISIBLE | WS_HSCROLL | WS_VSCROLL,
		CW_USEDEFAULT, 0, CW_USEDEFAULT, 0, hMain, nullptr, hInstance, nullptr);

	HDC dc = GetWindowDC(hMain);
	xDPI = GetDeviceCaps(dc, LOGPIXELSX);
	yDPI = GetDeviceCaps(dc, LOGPIXELSY);
	ReleaseDC(hMain, dc);
	ShowWindow(hMain, nCmdShow);
	mSetScrollInfo(hView, FALSE);
	UpdateWindow(hMain);

	return TRUE;
}

//
//  FUNCTION: WndProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the main window.
//
//  WM_COMMAND	- process the application menu
//  WM_PAINT	- Paint the main window
//  WM_DESTROY	- post a quit message and return
//
//
LRESULT CALLBACK MainWndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	int wmId, wmEvent;
	switch (message)
	{
	case WM_COMMAND:
		wmId    = LOWORD(wParam);
		wmEvent = HIWORD(wParam);
		// Parse the menu selections:
		switch (wmId)
		{
		case IDM_EXIT:
			DestroyWindow(hWnd);
			break;
		case ID_FILE_OPEN:
			if (OpenPdfFile(hWnd))
			{
				mSetScrollInfo(hView, FALSE);
				InvalidateRect(hView, nullptr, FALSE);
				UpdateWindow(hView);
			}
			break;
		case ID_FILE_PRINT:
			PrintPdfFile(hWnd);
			break;
		case ID_FILE_CLOSE:
			if (ClosePdfFile())
			{
				mSetScrollInfo(hView, FALSE);
				InvalidateRect(hView, nullptr, FALSE);
				UpdateWindow(hView);
			}
			break;
		case ID_ACTIONS_ACTUALSIZE:
		case ID_ACTIONS_ZOOMIN:
		case ID_ACTIONS_ZOOMOUT:
			if (ChangeZoom(wmId))
			{
				mSetScrollInfo(hView, FALSE);
				InvalidateRect(hView, nullptr, FALSE);
				UpdateWindow(hView);
			}
			break;
		case ID_ACTIONS_FIRSTPAGE:
		case ID_ACTIONS_LASTPAGE:
		case ID_ACTIONS_PREVIOUSPAGE:
		case ID_ACTIONS_NEXTPAGE:
			if (ChangePage(wmId))
			{
				mSetScrollInfo(hView, FALSE);
				InvalidateRect(hView, nullptr, FALSE);
				UpdateWindow(hView);
			}
			break;
		default:
			return DefWindowProcW(hWnd, message, wParam, lParam);
		}
		break;
	case WM_DESTROY:
		PostQuitMessage(0);
		break;
	case WM_SIZE:
		{
//			DefWindowProc(hWnd, message, wParam, lParam);
			SendMessageW(hStatusBar, message, wParam, lParam);
			RECT rc;
			::GetClientRect(hWnd, &rc);
			RECT sr = rc;
			::GetWindowRect(hStatusBar, &sr);
			rc.bottom -= sr.bottom - sr.top;
			::MoveWindow(hView, rc.left, rc.top, rc.right - rc.left, rc.bottom - rc.top, TRUE);
		}
		break;
	default:
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}

LRESULT CALLBACK ChildWndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	SCROLLINFO si;
	int xPos;
	int yPos;
	switch (message)
	{
	case WM_PAINT:
		doPaint(hWnd);
		break;
	case WM_DESTROY:
//		PostQuitMessage(0);
		break;
	case WM_SIZE:
		{
			LRESULT lr = DefWindowProc(hWnd, message, wParam, lParam);
			mSetScrollInfo(hWnd);
			return lr;
		}
		break;
   case WM_HSCROLL:
		 // Get all the vertial scroll bar information
		 si.cbSize = sizeof (si);
		 si.fMask  = SIF_ALL;
		 // Save the position for comparison later on
		 GetScrollInfo (hWnd, SB_HORZ, &si);
		 xPos = si.nPos;
		 switch (LOWORD (wParam))
		 {
		 // user clicked left arrow
		 case SB_LINELEFT:
			  si.nPos -= 1;
			  break;

		 // user clicked right arrow
		 case SB_LINERIGHT:
			  si.nPos += 1;
			  break;

		 // user clicked the scroll bar shaft left of the scroll box
		 case SB_PAGELEFT:
			  si.nPos -= si.nPage;
			  break;

		 // user clicked the scroll bar shaft right of the scroll box
		 case SB_PAGERIGHT:
			  si.nPos += si.nPage;
			  break;

		 // user dragged the scroll box
		 case SB_THUMBTRACK:
			  si.nPos = si.nTrackPos;
			  break;

		 default :
			  break;
		 }
		 // Set the position and then retrieve it.  Due to adjustments
		 //   by Windows it may not be the same as the value set.
		 si.fMask = SIF_POS;
		 SetScrollInfo (hWnd, SB_HORZ, &si, TRUE);
		 GetScrollInfo (hWnd, SB_HORZ, &si);

		 // If the position has changed, scroll the window
		 curXpos = si.nPos;
		 if (si.nPos != xPos)
		 {
			ScrollWindow(hWnd, xPos - si.nPos, 0, nullptr, nullptr);
		 }
		 break;
	case WM_VSCROLL:
		 // Get all the vertial scroll bar information
		 si.cbSize = sizeof (si);
		 si.fMask  = SIF_ALL;
		 GetScrollInfo (hWnd, SB_VERT, &si);
		 // Save the position for comparison later on
		 yPos = si.nPos;
		 switch (LOWORD (wParam))
		 {
		 // user clicked the HOME keyboard key
		 case SB_TOP:
			  si.nPos = si.nMin;
			  break;

		 // user clicked the END keyboard key
		 case SB_BOTTOM:
			  si.nPos = si.nMax;
			  break;

		 // user clicked the top arrow
		 case SB_LINEUP:
			  si.nPos -= 1;
			  break;

		 // user clicked the bottom arrow
		 case SB_LINEDOWN:
			  si.nPos += 1;
			  break;

		 // user clicked the scroll bar shaft above the scroll box
		 case SB_PAGEUP:
			  si.nPos -= si.nPage;
			  break;

		 // user clicked the scroll bar shaft below the scroll box
		 case SB_PAGEDOWN:
			  si.nPos += si.nPage;
			  break;

		 // user dragged the scroll box
		 case SB_THUMBTRACK:
			  si.nPos = si.nTrackPos;
			  break;

		 default:
			  break;
		 }
		 // Set the position and then retrieve it.  Due to adjustments
		 //   by Windows it may not be the same as the value set.
		 si.fMask = SIF_POS;
		 SetScrollInfo (hWnd, SB_VERT, &si, TRUE);
		 GetScrollInfo (hWnd, SB_VERT, &si);
		 // If the position has changed, scroll window and update it
		 curYpos = si.nPos;
		 if (si.nPos != yPos)
		 {
			ScrollWindow(hWnd, 0, yPos - si.nPos, nullptr, nullptr);
			UpdateWindow (hWnd);
		 }
		 break;
	default:
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}

// Message handler for dialog box.
int CALLBACK PasswordDlg(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	switch (message)
	{
	case WM_INITDIALOG:
		return (INT_PTR)TRUE;

	case WM_COMMAND:
		if ((LOWORD(wParam) == IDOK) || (LOWORD(wParam) == IDCANCEL))
		{
			pass_len = 0;
			if (LOWORD(wParam) == IDOK)
			{
				pass_len = GetDlgItemTextA(hDlg, IDC_PWD, password, sizeof(password));
			}
			EndDialog(hDlg, LOWORD(wParam));
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

void HandleSettingsChanged()
{
	double pw = 0;
	double ph = 0;
	pixPageHeigth = -1;
	pixPageWidth = -1;
	HRESULT hr = PXCV_GetPageDimensions(curDoc, curPage, &pw, &ph);
	if (FAILED(hr))
		return;
	pixPageWidth = (LONG)(pw * xDPI * zoom / 100.0 / 72.0 + 0.5);
	pixPageHeigth = (LONG)(ph * yDPI * zoom / 100.0 / 72.0 + 0.5);
	WCHAR buf[128];
	wsprintfW(buf, L"Page %d of %d, %d.%03d", curPage + 1, pagesCount, (LONG)zoom, ((LONG)(zoom * 1000)) % 1000);
	size_t i = 0;
	while (buf[i] != L'\0')
		i++;
	while (i > 0)
	{
		i--;
		if (buf[i] != L'0')
			break;
	}
	if ((i > 0) && (buf[i] == L'.'))
		i--;
	buf[i + 1] = L'%';
	buf[i + 2] = L'\0';
	::SendMessage(hStatusBar, SB_SETTEXTW, 0, (LPARAM)buf);
}

#define c_zoom_max		6400.0
#define c_zoom_min		3.125

BOOL ChangeZoom(int wmId)
{
	if (curDoc == nullptr)
		return FALSE;
	double new_zoom = zoom;
	switch (wmId)
	{
	case ID_ACTIONS_ZOOMIN:
		new_zoom *= 2;
		if (new_zoom > c_zoom_max)
			new_zoom = c_zoom_max;
		break;
	case ID_ACTIONS_ZOOMOUT:
		new_zoom /= 2;
		if (new_zoom < c_zoom_min)
			new_zoom = c_zoom_min;
		break;
	case ID_ACTIONS_ACTUALSIZE:
		new_zoom = 100.0;
		break;
	}
	if (new_zoom == zoom)
		return FALSE;
	zoom = new_zoom;
	HandleSettingsChanged();
	return TRUE;
}

BOOL ChangePage(int wmId)
{
	if (curDoc == nullptr)
		return FALSE;
	DWORD current_page = curPage;
	switch (wmId)
	{
	case ID_ACTIONS_FIRSTPAGE:
		current_page = 0;
		break;
	case ID_ACTIONS_LASTPAGE:
		current_page = pagesCount - 1;
		break;
	case ID_ACTIONS_NEXTPAGE:
		if (current_page + 1 < pagesCount)
			current_page++;
		break;
	case ID_ACTIONS_PREVIOUSPAGE:
		if (current_page > 0)
			current_page--;
		break;
	}
	if (current_page == curPage)
		return FALSE;
	PXCV_ReleasePageCachedData(curDoc, curPage, pxvrcd_ReleaseDocumentImages);
	curPage = current_page;
	HandleSettingsChanged();
	return TRUE;
}

BOOL OpenPdfFile(HWND hWnd)
{
	WCHAR fname[MAX_PATH + 1] = {0};
	OPENFILENAMEW ofn = {sizeof(OPENFILENAMEW)};
	ofn.hwndOwner = hWnd;
	ofn.lpstrFilter = L"PDF File (*.pdf)\0*.pdf\0\0";
	ofn.lpstrFile = fname;
	ofn.nMaxFile = MAX_PATH;
	ofn.lpstrTitle = L"Select PDF file";
	ofn.Flags = OFN_ENABLESIZING | OFN_EXPLORER | OFN_FILEMUSTEXIST | OFN_LONGNAMES;
	ofn.lpstrDefExt = L"pdf";
	if (!::GetOpenFileNameW(&ofn))
		return FALSE;
	ClosePdfFile();
	HRESULT hr = S_OK;
	BOOL bShowError = TRUE;
	do
	{
		hr = PXCV_Init(&curDoc, nullptr, nullptr);
		if (FAILED(hr))
			break;
		hr = PXCV_ReadDocumentW(curDoc, fname, 0);
		if (hr == PS40_ERR_DocEncrypted)
		{
			// ask password
			while (true)
			{
				pass_len = 0;
				DialogBoxW(hInst, MAKEINTRESOURCEW(IDD_PASSWORD_DLG), hWnd, (DLGPROC)PasswordDlg);
				if (pass_len > 0)
				{
					// password was supplied, check it
					hr = PXCV_CheckPassword(curDoc, (BYTE*)password, pass_len);
					if (SUCCEEDED(hr))
						break;
				}
				else
				{
					// Cancel button was pressed, skip document opening
					hr = E_FAIL;
					bShowError = FALSE;
					break;
				}
			}
			if (SUCCEEDED(hr))
				hr = PXCV_FinishReadDocument(curDoc, 0);
		}
		if (FAILED(hr))
			break;
		hr = PXCV_GetPagesCount(curDoc, &pagesCount);
		if (FAILED(hr))
			break;
		curPage = 0;
		zoom = 100;
		HandleSettingsChanged();
	}
	while (false);
	if (FAILED(hr))
	{
		PXCV_Delete(curDoc);
		curDoc = nullptr;
		if (bShowError)
		{
			// Show error description
			LONG sev_len = PXCV_Err_FormatSeverity(hr, nullptr, 0);
			LONG fac_len = PXCV_Err_FormatFacility(hr, nullptr, 0);
			LONG cod_len = PXCV_Err_FormatErrorCode(hr, nullptr, 0);
			if ((sev_len > 0) && (fac_len > 0) && (cod_len > 0))
			{
				LONG bs = sev_len + fac_len + cod_len + 5;
				CHAR* buf = new CHAR[bs];
				if (buf == nullptr)
				{
					WCHAR lbuf[128];
					wsprintfW(lbuf, L"Error allocating %d bytes", bs);
					MessageBoxW(hMain, lbuf, L"Error", MB_OK | MB_ICONERROR);
				}
				else
				{
					LONG pos = 0;
					sev_len = PXCV_Err_FormatSeverity(hr, buf + pos, bs - pos);
					if (sev_len >= 0)
						pos += sev_len -1;
					buf[pos] = '[';
					pos++;
					fac_len = PXCV_Err_FormatFacility(hr, buf + pos, bs - pos);
					if (fac_len >= 0)
						pos += fac_len - 1;
					buf[pos] = ']';
					buf[pos + 1] = ':';
					buf[pos + 2] = ' ';
					pos += 3;
					fac_len = PXCV_Err_FormatErrorCode(hr, buf + pos, bs - pos);
					MessageBoxA(hMain, buf, "Error", MB_OK | MB_ICONERROR);
					delete[] buf;
				}
			}
			else
			{
				WCHAR lbuf[128];
				wsprintfW(lbuf, L"Unknown error 0x%08x", hr);
				MessageBoxW(hMain, lbuf, L"Error", MB_OK | MB_ICONERROR);
			}
		}
		return TRUE;
	}
	::SetWindowTextW(hMain, fname);
	return TRUE;
}

BOOL ClosePdfFile()
{
	if (curDoc != nullptr)
	{
		PXCV_Delete(curDoc);
		curPage = 0;
		curDoc = nullptr;
		pixPageHeigth = pixPageWidth = -1;
		::SetWindowTextW(hMain, szTitle);
		return TRUE;
	}
	return FALSE;
}

void MakeProp(LONG& w, LONG& h, LONG ppage_w, LONG ppage_h, double dpage_w, double dpage_h)
{
	double kw = (double)ppage_w / dpage_w;
	double kh = (double)ppage_h / dpage_h;
	if (kw > kh)
		kw = kh;
	w = (LONG)(dpage_w * kw);
	h = (LONG)(dpage_h * kw);
}

void PrintPdfFile(HWND hParentWnd)
{
	if (curDoc == nullptr)
		return;
	DWORD pagescount = 0;
	HRESULT hr = PXCV_GetPagesCount(curDoc, &pagescount);
	if (FAILED(hr))
		return;
	//
	PRINTDLG pdlg = {sizeof(PRINTDLG)};
	//
	pdlg.hwndOwner = hParentWnd;
	pdlg.Flags = PD_NOSELECTION | PD_RETURNDC;
	pdlg.nMinPage = 1;
	pdlg.nMaxPage = (WORD)pagescount;
	pdlg.nCopies = 1;

	if (!PrintDlg(&pdlg))
		return;
	DWORD nStartPage = 1;
	DWORD nEndPage = pagescount;
	if (pdlg.Flags & PD_PAGENUMS)
	{
		nStartPage = pdlg.nFromPage;
		nEndPage = pdlg.nToPage;
	}
	nStartPage--;
	nEndPage--;

	DOCINFO di = {sizeof(DOCINFO)};
	di.lpszDocName = _T("PXC-View PDF Print");
	// Now Getting Information from DC
	SIZE physicalSize;
	SIZE margin;
	SIZE printigSize;
	physicalSize.cx = GetDeviceCaps(pdlg.hDC, PHYSICALWIDTH);
	physicalSize.cy = GetDeviceCaps(pdlg.hDC, PHYSICALHEIGHT);
	margin.cx = GetDeviceCaps(pdlg.hDC, PHYSICALOFFSETX);
	margin.cy = GetDeviceCaps(pdlg.hDC, PHYSICALOFFSETY);
	printigSize.cx = GetDeviceCaps(pdlg.hDC, HORZRES);
	printigSize.cy = GetDeviceCaps(pdlg.hDC, VERTRES);
	//
	RECT or_prect;
	or_prect.left = margin.cx;
	or_prect.right = or_prect.left + printigSize.cx;
	or_prect.top = margin.cy;
	or_prect.bottom = or_prect.top + printigSize.cy;
	PXV_CommonRenderParameters crp;
	BOOL bRotated = (physicalSize.cx > physicalSize.cy);
	crp.Flags = pxvrpf_UseVectorRenderer;
	crp.RenderTarget = pxvrm_Printing;
	crp.DrawRect = nullptr;
	//
	if (::StartDoc(pdlg.hDC, &di) > 0)
	{

		for (DWORD i = (DWORD)nStartPage; i <= (DWORD)nEndPage; i++)
		{
			::StartPage(pdlg.hDC);
			//
			double doc_page_w, doc_page_h;
			PXCV_GetPageDimensions(curDoc, i, &doc_page_w, &doc_page_h);
			LONG pw, ph;
			RECT pr;
/** /
			// Fit no proportional
			::CopyRect(&pr, &or_prect);
/*/
			// Proportional fit and center
			MakeProp(pw, ph, or_prect.right - or_prect.left, or_prect.bottom - or_prect.top, doc_page_w, doc_page_h);
			pr.left = or_prect.left + (or_prect.right - or_prect.left - pw) / 2;
			pr.right = pr.left + pw;
			pr.top = or_prect.top + (or_prect.bottom - or_prect.top - ph) / 2;
			pr.bottom = pr.top + ph;
/**/
			crp.WholePageRect = &pr;
			PXCV_DrawPageToDC(curDoc, i, pdlg.hDC, &crp);
			::EndPage(pdlg.hDC);
		}
		::EndDoc(pdlg.hDC);
	}
	DeleteDC(pdlg.hDC);
}