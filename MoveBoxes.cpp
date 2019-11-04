// MoveBoxes.cpp : Defines the entry point for the console application.
//
#include "stdafx.h"
#include <graphics.h>
#include <conio.h>
#include<mmsystem.h>
#include <time.h> 
#pragma comment(lib, "WINMM.LIB")
#define PI 3.14159265
struct men{
	int x;
	int y;
};
struct box{
	int x;
	int y;
	int state;
};
struct place{
	struct men cat;
	int boxnumber;
	struct box *b;
	int manchange;
	int changeboxnumber;
};
struct brick{
	int x;
	int y;
};
struct bricklist{
	int number;
	struct brick *list;
};
struct target{
	int x;
	int y;
};
struct targetlist{
	int number;
	struct target *list;
};
void drawbrick(int left, int top)
{
	COLORREF color1 = RGB(168, 60, 30);
	setlinestyle(PS_SOLID | PS_ENDCAP_FLAT, 0);
	setfillcolor(WHITE);
	fillrectangle(left, top, left + 80, top + 80);
	setlinestyle(PS_SOLID | PS_ENDCAP_FLAT, 1);
	setfillcolor(color1);
	fillrectangle(left, top + 2, left + 80, top + 78);
	setlinecolor(WHITE);
	setlinestyle(PS_SOLID | PS_ENDCAP_FLAT, 4);
	line(left, top + 20, left + 80, top + 20);
	line(left, top + 40, left + 80, top + 40);
	line(left, top + 60, left + 80, top + 60);	
	line(left + 2, top + 20, left + 2, top + 40);
	line(left + 2, top + 60, left + 2, top + 80);
	line(left + 78, top + 20, left + 78, top + 40);
	line(left + 78, top + 60, left + 78, top + 80);
	setlinestyle(PS_SOLID | PS_ENDCAP_FLAT, 8);
	line(left + 40, top, left + 40, top + 20);
	line(left + 40, top + 40, left + 40, top + 60);
}
void drawtarget(int left, int top)
{
	COLORREF color1 = RGB(255, 0, 0);
	setlinecolor(color1);
	setlinestyle(PS_SOLID | PS_ENDCAP_ROUND, 10);
	line(left + 20, top + 20, left + 60, top + 60);
	line(left + 20, top + 60, left + 60, top + 20);
}
void drawbox(int left, int top, int state)
{
	COLORREF color1 = RGB(0, 255, 0);
	COLORREF color2 = RGB(128, 128, 0);
	COLORREF color3 = RGB(60, 12, 60);
	if (state)
	{
		setlinecolor(color2);
		setlinestyle(PS_SOLID | PS_ENDCAP_ROUND, 3);
		setfillcolor(color3);
		bar3d(left + 10, top + 10, left + 70, top + 70, 9, 1);
		line(left + 10, top + 10, left + 70, top + 70);
	}
	else
	{
		setlinecolor(color1);
		setlinestyle(PS_SOLID | PS_ENDCAP_ROUND, 3);
		setfillcolor(color3);
		bar3d(left + 10, top + 10, left + 70, top + 70, 9, 1);
		line(left + 10, top + 10, left + 70, top + 70);
	}
}
void drawman(int left, int top)
{
	setlinecolor(WHITE);
	setlinestyle(PS_SOLID | PS_ENDCAP_FLAT, 3);
	setfillcolor(0x24c097);
	fillroundrect(left+19, top+21, left+61, top+64, 10, 10);
	fillpie(left+19, top+5, left+61, top+44, 0, PI);
	circle(left+31, top+15, 1);
	circle(left+49, top+15, 1);
	fillellipse(left+25, top+1, left+29, top+5);
	line(left+26, top+5, left+28, top+8);
	line(left+29, top+2, left+32, top+7);
	fillellipse(left+55, top+1, left+51, top+5);
	line(left+54, top+5, left+52, top+8);
	line(left+51, top+2, left+48, top+7);
	setlinecolor(0x24c097);
	setlinestyle(PS_SOLID | PS_ENDCAP_ROUND, 2);
	line(left+27, top+3, left+33, top+12);
	line(left+53, top+3, left+47, top+12);
	setlinecolor(WHITE);
	setlinestyle(PS_SOLID | PS_ENDCAP_FLAT, 3);
	fillroundrect(left+7, top+25, left+19, top+55, 12, 12);
	fillroundrect(left+73, top+25, left+61, top+55, 12, 12);
	fillpie(left+26, top+67, left+38, top+79, PI, PI * 2);
	line(left+26, top+64, left+26, top+73);
	line(left + 38, top+64, left + 38, top+73);
	solidroundrect(left+27, top+53, left+36, top+77, 9, 9);
	fillpie(left+54, top+67, left+42, top+79, PI, PI * 2);
	line(left + 54, top+64, left + 54, top+73);
	line(left + 42, top+64, left + 42, top+73);
	solidroundrect(left+53, top+53, left+44, top+77, 9, 9);
}
void drawsteps(int step)
{
	LOGFONT f;
	gettextstyle(&f);
	f.lfHeight = 30;
	_tcscpy_s(f.lfFaceName, _T("黑体"));
	f.lfQuality = ANTIALIASED_QUALITY;
	settextstyle(&f);
	COLORREF color1 = RGB(130, 31, 128);
	RECT r[2] = { { 15, 10, 65, 40 }, { 15, 40, 65, 70 } };
	TCHAR s[80], c;
	int i=0,j=0,k;
	do{
		s[i++] = "0123456789"[step % 10];
		step /= 10;
	} while (step > 0);
	k = i - 1;
	s[i] = '\0';
	while (j < k)
	{
		c = s[j];
		s[j] = s[k];
		s[k] = c;
		j++;
		k--;
	}
	setfillcolor(BLACK);
	setlinecolor(BLACK);
	setlinestyle(PS_SOLID | PS_ENDCAP_ROUND, 0);
	solidrectangle(0, 0, 80, 80);
	settextcolor(color1);
	drawtext(_T("步数"), r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
	drawtext(s, r + 1, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
}
void drawreturnbutton(int x)
{
	LOGFONT f;
	gettextstyle(&f);
	f.lfHeight = 28;
	_tcscpy_s(f.lfFaceName, _T("黑体"));
	f.lfQuality = ANTIALIASED_QUALITY;
	settextstyle(&f);
	COLORREF color1 = RGB(130, 31, 128);
	RECT r = { x - 65, 15, x - 15, 65 };
	setfillcolor(BLACK);
	setlinecolor(BLACK);
	setlinestyle(PS_SOLID | PS_ENDCAP_ROUND, 10);
	solidrectangle(x - 80, 0, x, 80);
	settextcolor(color1);
	drawtext(_T("返回"), &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
}
void win(int x, int y)
{
	COLORREF color1 = RGB(255, 0, 0);
	RECT r = {x/2-160, y/2-50, x/2+160, y/2+50};
	LOGFONT f;
	gettextstyle(&f);
	f.lfHeight = 60;
	f.lfItalic = false;
	f.lfQuality = ANTIALIASED_QUALITY;
	_tcscpy_s(f.lfFaceName, _T("宋体"));
	settextcolor(color1);
	settextstyle(&f);
	setbkmode(TRANSPARENT);
	drawtext(_T("你赢了!"), &r, DT_CENTER);
}
void preface()
{
	initgraph(800, 640);
	LOGFONT f;
	gettextstyle(&f);
	f.lfHeight = 80;
	_tcscpy_s(f.lfFaceName, _T("宋体"));
	f.lfQuality = ANTIALIASED_QUALITY;
	settextstyle(&f);
	settextcolor(WHITE);
	RECT r[4] = { { 200, 100, 600, 250 }, { 200, 250, 600, 400 }, { 200, 400, 600, 550 }, { 200, 550, 600, 700 } };
	drawtext(_T("制作"), r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
	f.lfHeight = 60;
	settextstyle(&f);
	drawtext(_T("化学化工学院"), r + 1, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
	f.lfHeight = 40;
	settextstyle(&f);
	drawtext(_T("141130011 陈义旻"), r + 2, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
	drawtext(_T("141130079 沈成桢"), r + 3, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
	clock_t start, end;
	int i = 0;
	start = end = clock();
	for (i = 0; i<2; i++)
	{
		Sleep(1000);
		end = clock();
	}
	clearcliprgn();
	closegraph();
}
void selectlevel(int level)
{	
	COLORREF color1 = RGB(255, 0, 0);
	COLORREF color2 = RGB(0, 255, 0);
	COLORREF color3 = RGB(240, 40, 126);
	RECT r[5] = { { 300, 400, 500, 440 }, { 300, 440, 500, 480 }, { 300, 480, 500, 520 }, { 300, 520, 500, 560 }, { 300, 560, 500, 600 }};
	LOGFONT f;
	gettextstyle(&f);
	f.lfHeight = 40;
	f.lfItalic = false;
	_tcscpy_s(f.lfFaceName, _T("隶书"));
	f.lfQuality = ANTIALIASED_QUALITY;
	settextstyle(&f);
	switch (level){
	case 1:settextcolor(color1);
		drawtext(_T("第1关"), r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		settextcolor(color2);
		drawtext(_T("第2关"), r + 1, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		drawtext(_T("第3关"), r + 2, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		drawtext(_T("说明"), r + 3, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		drawtext(_T("退出"), r + 4, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		break;
	case 2:settextcolor(color1);
		drawtext(_T("第2关"), r + 1, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		settextcolor(color2);
		drawtext(_T("第1关"), r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		drawtext(_T("第3关"), r + 2, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		drawtext(_T("说明"), r + 3, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		drawtext(_T("退出"), r + 4, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		break;
	case 3:settextcolor(color1);
		drawtext(_T("第3关"), r + 2, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		settextcolor(color2);
		drawtext(_T("第1关"), r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		drawtext(_T("第2关"), r + 1, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		drawtext(_T("说明"), r + 3, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		drawtext(_T("退出"), r + 4, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		break;
	case 4:settextcolor(color1);
		drawtext(_T("说明"), r + 3, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		settextcolor(color2);
		drawtext(_T("第1关"), r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		drawtext(_T("第2关"), r + 1, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		drawtext(_T("第3关"), r + 2, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		drawtext(_T("退出"), r + 4, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		break;
	case 5:settextcolor(color1);
		drawtext(_T("退出"), r + 4, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		settextcolor(color2);
		drawtext(_T("第1关"), r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		drawtext(_T("第2关"), r + 1, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		drawtext(_T("第3关"), r + 2, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		drawtext(_T("说明"), r + 3, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		break;
	default:settextcolor(color1);
		drawtext(_T("第1关"), r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		settextcolor(color2);
		drawtext(_T("第2关"), r + 1, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		drawtext(_T("第3关"), r + 2, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		drawtext(_T("说明"), r + 3, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		drawtext(_T("退出"), r + 4, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
	}
}
struct place drawcharacters(struct place p, struct place n, int step, struct targetlist source)
{
	int i;
	if (n.changeboxnumber)
	{
		int left = 80 * (p.b + n.changeboxnumber - 1)->x;
		int top = 80 * (p.b + n.changeboxnumber - 1)->y;
		setfillcolor(BLACK);
		setlinecolor(BLACK);
		setlinestyle(PS_SOLID | PS_ENDCAP_ROUND, 0);		
		fillrectangle(left, top, left + 80, top + 80);
	}
	if (n.manchange)
	{		
		int left = 80 * (p.cat.x);
		int top = 80 * (p.cat.y);
		setfillcolor(BLACK);
		setlinecolor(BLACK);
		setlinestyle(PS_SOLID | PS_ENDCAP_ROUND, 0);
		fillrectangle(left, top, left + 80, top + 80);
		for (i = 0; i < n.boxnumber; i++)
		{
			if (p.cat.x == (source.list + i)->x && p.cat.x == (source.list + i)->x)
				break;
		}
		if (i!=n.boxnumber)
			drawtarget(80 * (source.list + i)->x, 80 * (source.list + i)->y);
	}
	for (i = 0; i < source.number; i++)
		drawtarget(80 * (source.list + i)->x, 80 * (source.list + i)->y);
	for (i = 0; i < n.boxnumber; i++)
		drawbox(80 * (n.b + i)->x, 80 * (n.b + i)->y, (n.b + i)->state);
	drawman(80 * n.cat.x, 80 * n.cat.y);	
	drawsteps(step);
	return n;
}
int judge(struct brick *a, struct place *b, struct target *c, int key, int bricknumber, int *step)
{
	switch (key)
	{
	case 72:
	case 'w':{
		int i, j = 1;
		for (i = 0; i < bricknumber; i++)
			if ((a + i)->x == b->cat.x && (a + i)->y == b->cat.y - 1)
			{
				j = 0;
				break;
			}
		if (j)
		{
			int s = b->boxnumber;
			for (i = 0; i < b->boxnumber; i++)
				if ((b->b + i)->x == b->cat.x && (b->b + i)->y == b->cat.y - 1)
				{
					s = i;
					break;
				}
			if (s != b->boxnumber)
			{
				int k = 1;
				for (i = 0; i < bricknumber; i++)
					if ((a + i)->x == b->cat.x && (a + i)->y == b->cat.y - 2)
					{
						k = 0;
						break;
					}
				if (k)
				{
					int w = 1;
					for (i = 0; i < b->boxnumber; i++)
						if ((b->b + i)->x == b->cat.x && (b->b + i)->y == b->cat.y - 2)
						{
							w = 0;
							break;
						}
					if (w)
					{
						b->manchange = 1;
						b->changeboxnumber = s + 1;
						b->cat.y--;
						(b->b + s)->y--;
					}
					else
					{
						b->manchange = 0;
						b->changeboxnumber = 0;
					}
				}
				else
				{
					b->manchange = 0;
					b->changeboxnumber = 0;
				}
			}
			else
			{
				b->manchange = 1;
				b->changeboxnumber = 0;
				b->cat.y--;
			}
		}
		else
		{
			b->manchange = 0;
			b->changeboxnumber = 0;
		}
		break; 
	}
	case 75:
	case 'a':{
		int i, j = 1;
		for (i = 0; i < bricknumber; i++)
			if ((a + i)->x == b->cat.x - 1 && (a + i)->y == b->cat.y)
			{
				j = 0;
				break;
			}
		if (j)
		{
			int s = b->boxnumber;
			for (i = 0; i < b->boxnumber; i++)
				if ((b->b + i)->x == b->cat.x - 1 && (b->b + i)->y == b->cat.y)
				{
					s = i;
					break;
				}
			if (s != b->boxnumber)
			{
				int k = 1;
				for (i = 0; i < bricknumber; i++)
					if ((a + i)->x == b->cat.x - 2 && (a + i)->y == b->cat.y)
					{
						k = 0;
						break;
					}
				if (k)
				{
					int w = 1;
					for (i = 0; i < b->boxnumber; i++)
						if ((b->b + i)->x == b->cat.x - 2 && (b->b + i)->y == b->cat.y)
						{
							w = 0;
							break;
						}
					if (w)
					{
						b->manchange = 1;
						b->changeboxnumber = s + 1;
						b->cat.x--;
						(b->b + s)->x--;
					}
					else
					{
						b->manchange = 0;
						b->changeboxnumber = 0;
					}
				}
				else
				{
					b->manchange = 0;
					b->changeboxnumber = 0;
				}
			}
			else
			{
				b->manchange = 1;
				b->changeboxnumber = 0;
				b->cat.x--;
			}
		}
		else
		{
			b->manchange = 0;
			b->changeboxnumber = 0;
		}
		break; 
	}
	case 80:
	case 's':{
		int i, j = 1;
		for (i = 0; i < bricknumber; i++)
			if ((a + i)->x == b->cat.x && (a + i)->y == b->cat.y + 1)
			{
				j = 0;
				break;
			}
		if (j)
		{
			int s = b->boxnumber;
			for (i = 0; i < b->boxnumber; i++)
				if ((b->b + i)->x == b->cat.x && (b->b + i)->y == b->cat.y + 1)
				{
					s = i;
					break;
				}
			if (s != b->boxnumber)
			{
				int k = 1;
				for (i = 0; i < bricknumber; i++)
					if ((a + i)->x == b->cat.x && (a + i)->y == b->cat.y + 2)
					{
						k = 0;
						break;
					}
				if (k)
				{
					int w = 1;
					for (i = 0; i < b->boxnumber; i++)
						if ((b->b + i)->x == b->cat.x && (b->b + i)->y == b->cat.y + 2)
						{
							w = 0;
							break;
						}
					if (w)
					{
						b->manchange = 1;
						b->changeboxnumber = s + 1;
						b->cat.y++;
						(b->b + s)->y++;
					}
					else
					{
						b->manchange = 0;
						b->changeboxnumber = 0;
					}
				}
				else
				{
					b->manchange = 0;
					b->changeboxnumber = 0;
				}
			}
			else
			{
				b->manchange = 1;
				b->changeboxnumber = 0;
				b->cat.y++;
			}
		}
		else
		{
			b->manchange = 0;
			b->changeboxnumber = 0;
		}
		break; 
	}
	case 77:
	case 'd':{
		int i, j = 1;
		for (i = 0; i < bricknumber; i++)
			if ((a + i)->x == b->cat.x + 1 && (a + i)->y == b->cat.y)
			{
				j = 0;
				break;
			}
		if (j)
		{
			int s = b->boxnumber;
			for (i = 0; i < b->boxnumber; i++)
				if ((b->b + i)->x == b->cat.x + 1 && (b->b + i)->y == b->cat.y)
				{
					s = i;
					break;
				}
			if (s != b->boxnumber)
			{
				int k = 1;
				for (i = 0; i < bricknumber; i++)
					if ((a + i)->x == b->cat.x + 2 && (a + i)->y == b->cat.y)
					{
						k = 0;
						break;
					}
				if (k)
				{
					int w = 1;
					for (i = 0; i < b->boxnumber; i++)
						if ((b->b + i)->x == b->cat.x + 2 && (b->b + i)->y == b->cat.y)
						{
							w = 0;
							break;
						}
					if (w)
					{
						b->manchange = 1;
						b->changeboxnumber = s + 1;
						b->cat.x++;
						(b->b + s)->x++;
					}
					else
					{
						b->manchange = 0;
						b->changeboxnumber = 0;
					}
				}
				else
				{
					b->manchange = 0;
					b->changeboxnumber = 0;
				}
			}
			else
			{
				b->manchange = 1;
				b->changeboxnumber = 0;
				b->cat.x++;
			}
		}
		else
		{
			b->manchange = 0;
			b->changeboxnumber = 0;
		}
		break; 
	}
	default: {
		b->manchange = 0;
		b->changeboxnumber = 0; }
	}
	*step += b->manchange;
	int m, n, p=0;
	for (m = 0; m < b->boxnumber; m++)
		(b->b + m)->state = 0;
	for (m = 0; m < b->boxnumber; m++)
		for (n = 0; n < b->boxnumber; n++)
			if ((b->b + m)->x == (c + n)->x && (b->b + m)->y == (c + n)->y)
			{
				(b->b + m)->state = 1;
				p++;
			}
	if (p == b->boxnumber)
		return 1;
	else
		return 0;
}
int levelone()
{
	struct brick brickone[41] = { { 0, 0 }, { 1, 0 }, { 2, 0 }, { 3, 0 }, { 4, 0 }, { 5, 0 }, { 6, 0 }, { 7, 0 }, { 8, 0 }, { 9, 0 }, { 0, 1 }, { 6, 1 }, { 9, 1 }, { 0, 2 }, { 9, 2 }, { 0, 3 }, { 5, 3 }, { 9, 3 }, { 0, 4 }, { 1, 4 }, { 2, 4 }, { 3, 4 }, { 5, 4 }, { 6, 4 }, { 7, 4 }, { 8, 4 }, { 9, 4 }, { 0, 5 }, { 9, 5 }, { 0, 6 }, { 9, 6 }, { 0, 7 }, { 1, 7 }, { 2, 7 }, { 3, 7 }, { 4, 7 }, { 5, 7 }, { 6, 7 }, { 7, 7 }, { 8, 7 }, { 9, 7 } };
	struct bricklist bricks = { 41, brickone };
	struct box boxone[4] = { { 3, 2, 0 }, { 2, 5, 0 }, { 4, 5, 0 }, { 6, 5, 0 } }, boxback[4];
	struct place one = { { 8, 5 }, 4, boxone, 0, 0 }, *p = &one, n, nb;
	struct target targetone[4] = { { 7, 1 }, { 7, 2 }, { 8, 2 }, { 8, 3 } };
	struct targetlist listone = { 4, targetone };
	int step = 0, x = 800, y = 640, i, j, c;
	struct MOUSEMSG m;
	for (i = 0; i < p->boxnumber; i++)
	{
		boxback[i].state = boxone[i].state;
		boxback[i].x = boxone[i].x;
		boxback[i].y = boxone[i].y;
	}
	n.cat.x = one.cat.x;
	n.cat.y = one.cat.y;
	n.boxnumber = one.boxnumber;
	n.b = boxback;
	n.manchange = one.manchange;
	n.changeboxnumber = one.changeboxnumber;
	mciSendString(TEXT("open music\\levelone.mp3 alias mysong1"), NULL, 0, NULL);
	mciSendString(TEXT("play mysong1 repeat"), NULL, 0, NULL);
	initgraph(x, y);
	for (i = 0; i < bricks.number; i++)
		drawbrick(80 * (bricks.list + i)->x, 80 * (bricks.list + i)->y);
	drawreturnbutton(x);
	nb = drawcharacters(n, *p, step, listone);
	for (i = 0; i < p->boxnumber; i++)
	{
		boxback[i].state = boxone[i].state;
		boxback[i].x = boxone[i].x;
		boxback[i].y = boxone[i].y;
	}
	n.cat.x = nb.cat.x;
	n.cat.y = nb.cat.y;
	n.boxnumber = nb.boxnumber;
	n.manchange = nb.manchange;
	n.changeboxnumber = nb.changeboxnumber;
	do{
		while (MouseHit())
		{
			m = GetMouseMsg();
			if (m.uMsg == WM_LBUTTONUP && m.x >= x - 80 && m.x <= x && m.y >= 0 && m.y <= 80)
			{
				mciSendString(TEXT("close mysong1"), NULL, 0, NULL);
				return 0;
			}
		}		
		c = _getch();
		i = judge(brickone, p, targetone, c, bricks.number, &step);
		nb = drawcharacters(n, *p, step, listone);
		for (j = 0; j < p->boxnumber; j++)
		{
			boxback[j].state = boxone[j].state;
			boxback[j].x = boxone[j].x;
			boxback[j].y = boxone[j].y;
		}
		n.cat.x = nb.cat.x;
		n.cat.y = nb.cat.y;
		n.boxnumber = nb.boxnumber;
		n.manchange = nb.manchange;
		n.changeboxnumber = nb.changeboxnumber;
		if (i == 1)
		{			
			win(x,y);
			break;
		}
		Sleep(50);
	} while (!(c == 27));
	if (i == 1)
	{
		do{
			while (MouseHit())
			{
				m = GetMouseMsg();
				if (m.uMsg == WM_LBUTTONUP && m.x >= x - 80 && m.x <= x && m.y >= 0 && m.y <= 80)
				{
					mciSendString(TEXT("close mysong1"), NULL, 0, NULL);
					return 0;
				}
			}
			c = _getch();
			Sleep(50);
		} while (!(c == 27));
	}
	mciSendString(TEXT("close mysong1"), NULL, 0, NULL);
	return 0;
}
int leveltwo()
{
	struct brick bricktwo[32] = { { 0, 0 }, { 1, 0 }, { 2, 0 }, { 3, 0 }, { 4, 0 }, { 5, 0 }, { 6, 0 }, { 7, 0 }, { 0, 1 }, { 7, 1 }, { 0, 2 }, { 7, 2 }, { 0, 3 }, { 5, 3 }, { 6, 3 }, { 7, 3 }, { 0, 4 }, { 1, 4 }, { 2, 4 }, { 7, 4 }, { 0, 5 }, { 7, 5 }, { 0, 6 }, { 7, 6 }, { 0, 7 }, { 1, 7 }, { 2, 7 }, { 3, 7 }, { 4, 7 }, { 5, 7 }, { 6, 7 }, { 7, 7 } };
	struct bricklist bricks = { 32, bricktwo };
	struct box boxtwo[6] = { { 2, 2, 0 }, { 3, 2, 0 }, { 4, 2, 0 }, { 3, 5, 0 }, { 4, 5, 0 }, { 5, 5, 0 } }, boxback[6];
	struct place two = { { 2, 5 }, 6, boxtwo, 0, 0 }, *p = &two, n, nb;
	struct target targettwo[6] = { { 2, 3 }, { 3, 3 }, { 4, 3 }, { 3, 4 }, { 4, 4 }, { 5, 4 } };
	struct targetlist listtwo = { 6, targettwo };
	int step = 0, x = 640, y = 640, i, j, c;
	struct MOUSEMSG m;
	for (i = 0; i < p->boxnumber; i++)
	{
		boxback[i].state = boxtwo[i].state;
		boxback[i].x = boxtwo[i].x;
		boxback[i].y = boxtwo[i].y;
	}
	n.cat.x = two.cat.x;
	n.cat.y = two.cat.y;
	n.boxnumber = two.boxnumber;
	n.b = boxback;
	n.manchange = two.manchange;
	n.changeboxnumber = two.changeboxnumber;
	mciSendString(TEXT("open music\\leveltwo.mp3 alias mysong2"), NULL, 0, NULL);
	mciSendString(TEXT("play mysong2 repeat"), NULL, 0, NULL);
	initgraph(x, y);
	for (i = 0; i < bricks.number; i++)
		drawbrick(80 * (bricks.list + i)->x, 80 * (bricks.list + i)->y);
	drawreturnbutton(x);
	nb = drawcharacters(n, *p, step, listtwo);
	for (i = 0; i < p->boxnumber; i++)
	{
		boxback[i].state = boxtwo[i].state;
		boxback[i].x = boxtwo[i].x;
		boxback[i].y = boxtwo[i].y;
	}
	n.cat.x = nb.cat.x;
	n.cat.y = nb.cat.y;
	n.boxnumber = nb.boxnumber;
	n.manchange = nb.manchange;
	n.changeboxnumber = nb.changeboxnumber;
	do
	{
		while (MouseHit())
		{
			m = GetMouseMsg();
			if (m.uMsg == WM_LBUTTONUP && m.x >= x - 80 && m.x <= x && m.y >= 0 && m.y <= 80)
			{
				mciSendString(TEXT("close mysong2"), NULL, 0, NULL);
				return 0;
			}
		}
		c = _getch();
		i = judge(bricktwo, p, targettwo, c, bricks.number, &step);
		nb = drawcharacters(n, *p, step, listtwo);
		for (j = 0; j < p->boxnumber; j++)
		{
			boxback[j].state = boxtwo[j].state;
			boxback[j].x = boxtwo[j].x;
			boxback[j].y = boxtwo[j].y;
		}
		n.cat.x = nb.cat.x;
		n.cat.y = nb.cat.y;
		n.boxnumber = nb.boxnumber;
		n.manchange = nb.manchange;
		n.changeboxnumber = nb.changeboxnumber;
		if (i == 1)
		{
			win(x,y);
			break;
		}
		Sleep(50);
	} while (!(c == 27));
	if (i == 1)
	{
		do{
			while (MouseHit())
			{
				m = GetMouseMsg();
				if (m.uMsg == WM_LBUTTONUP && m.x >= x - 80 && m.x <= x && m.y >= 0 && m.y <= 80)
				{
					mciSendString(TEXT("close mysong2"), NULL, 0, NULL);
					return 0;
				}
			}
			c = _getch();
			Sleep(50);
		} while (!(c == 27));
	}
	mciSendString(TEXT("close mysong2"), NULL, 0, NULL);
	return 0;
}
int levelthree()
{
	struct brick brickthree[24] = { { 0, 0 }, { 1, 0 }, { 2, 0 }, { 3, 0 }, { 4, 0 }, { 5, 0 }, { 6, 0 }, { 0, 1 }, { 6, 1 }, { 0, 2 }, { 6, 2 }, { 0, 3 }, { 6, 3 }, { 0, 4 }, { 6, 4 }, { 0, 5 }, { 6, 5 }, { 0, 6 }, { 1, 6 }, { 2, 6 }, { 3, 6 }, { 4, 6 }, { 5, 6 }, { 6, 6 } };
	struct bricklist bricks = { 24, brickthree };
	struct box boxthree[8] = { { 2, 2, 0 }, { 2, 3, 0 }, { 2, 4, 0 }, { 3, 2, 0 }, { 3, 4, 0 }, { 4, 2, 0 }, { 4, 3, 0 }, { 4, 4, 0 } }, boxback[8];
	struct place three = { { 3, 3 }, 8, boxthree, 0, 0 }, *p = &three, n, nb;
	struct target targetthree[8] = { { 1, 1 }, { 3, 5 }, { 1, 3 }, { 5, 1 }, { 3, 1 }, { 5, 5 }, { 1, 5 }, { 5, 3 } };
	struct targetlist listthree = { 8, targetthree };
	int step = 0, x = 560, y = 560, i, j, c;
	struct MOUSEMSG m;
	for (i = 0; i < p->boxnumber; i++)
	{
		boxback[i].state = boxthree[i].state;
		boxback[i].x = boxthree[i].x;
		boxback[i].y = boxthree[i].y;
	}
	n.cat.x = three.cat.x;
	n.cat.y = three.cat.y;
	n.boxnumber = three.boxnumber;
	n.b = boxback;
	n.manchange = three.manchange;
	n.changeboxnumber = three.changeboxnumber;
	mciSendString(TEXT("open music\\levelthree.mp3 alias mysong3"), NULL, 0, NULL);
	mciSendString(TEXT("play mysong3 repeat"), NULL, 0, NULL);
	initgraph(x, y);
	for (i = 0; i < bricks.number; i++)
		drawbrick(80 * (bricks.list + i)->x, 80 * (bricks.list + i)->y);
	drawreturnbutton(x);
	nb = drawcharacters(n, *p, step, listthree);
	for (i = 0; i < p->boxnumber; i++)
	{
		boxback[i].state = boxthree[i].state;
		boxback[i].x = boxthree[i].x;
		boxback[i].y = boxthree[i].y;
	}
	n.cat.x = nb.cat.x;
	n.cat.y = nb.cat.y;
	n.boxnumber = nb.boxnumber;
	n.manchange = nb.manchange;
	n.changeboxnumber = nb.changeboxnumber;
	do{
		while (MouseHit())
		{
			m = GetMouseMsg();
			if (m.uMsg == WM_LBUTTONUP && m.x >= x - 80 && m.x <= x && m.y >= 0 && m.y <= 80)
			{
				mciSendString(TEXT("close mysong3"), NULL, 0, NULL);
				return 0;
			}
		}
		c = _getch();
		i = judge(brickthree, p, targetthree, c, bricks.number, &step);
		nb = drawcharacters(n, *p, step, listthree);
		for (j = 0; j < p->boxnumber; j++)
		{
			boxback[j].state = boxthree[j].state;
			boxback[j].x = boxthree[j].x;
			boxback[j].y = boxthree[j].y;
		}
		n.cat.x = nb.cat.x;
		n.cat.y = nb.cat.y;
		n.boxnumber = nb.boxnumber;
		n.manchange = nb.manchange;
		n.changeboxnumber = nb.changeboxnumber;
		if (i == 1)
		{
			win(x,y);
			break;
		}
		Sleep(50);
	} while (!(c == 27));
	if (i == 1)
	{
		do{
			while (MouseHit())
			{
				m = GetMouseMsg();
				if (m.uMsg == WM_LBUTTONUP && m.x >= x - 80 && m.x <= x && m.y >= 0 && m.y <= 80)
				{
					mciSendString(TEXT("close mysong3"), NULL, 0, NULL);
					return 0;
				}
			}
			c = _getch();
			Sleep(50);
		} while (!(c == 27));
	}
	mciSendString(TEXT("close mysong3"), NULL, 0, NULL);
	return 0;
}
int introduction()
{
	struct MOUSEMSG m;
	FILE *fp;
	long int i;
	int numclosed;
	errno_t err;
	err = fopen_s( &fp, "license.txt", "rt+");
	if (err != NULL)
	{
		printf("Error\n");
		_getch();
		exit(1);
	}
	else
		fscanf_s(fp, "The license has been read for %ld times.", &i, 80);
	initgraph(800, 640);
	loadimage(NULL, _T("pictures\\1.bmp"));
	drawreturnbutton(800);
	numclosed = _fcloseall();
	while (1)
	{
		while (MouseHit())
		{
			m = GetMouseMsg();
			if (m.uMsg == WM_LBUTTONUP && m.x >= 720 && m.x <= 800 && m.y >= 0 && m.y <= 80)
			{
				i++;
				err = fopen_s(&fp, "license.txt", "w");
				if (err != NULL)
				{
					printf("Error!\n");
					_getch();
					exit(1);
				}
				else
				{
					fprintf_s(fp, "The license has been read for %ld times.\n", i);
					numclosed = _fcloseall();
				}
				return 0;
			}
		}
		Sleep(50);
	}
}
int _tmain(int argc, _TCHAR* argv[])
{
	int level = 1;
	struct MOUSEMSG m;
	COLORREF title = RGB(240, 40, 126);
	RECT r = { 0, 0, 800, 400 };
	LOGFONT f;
	preface();
	while (true)
	{
		initgraph(800, 640);
		mciSendString(TEXT("open music\\selectlevel.mp3 alias mysong"), NULL, 0, NULL);
		mciSendString(TEXT("play mysong repeat"), NULL, 0, NULL);
		gettextstyle(&f);
		f.lfHeight = 120;
		f.lfItalic = true;
		f.lfQuality = ANTIALIASED_QUALITY;
		_tcscpy_s(f.lfFaceName, _T("宋体"));
		settextcolor(title);
		settextstyle(&f);
		drawtext(_T("推箱子"), &r, DT_CENTER | DT_VCENTER | DT_SINGLELINE);
		do{
			selectlevel(level);
			while (MouseHit())
			{
				m = GetMouseMsg();
				if (m.x >= 340 && m.x <= 460)
					level = (m.y - 400) / 40 + 1;
			}
			Sleep(50);
		} while (!(m.uMsg == WM_LBUTTONDOWN && level >= 1 && level <= 5));
		switch (level)
		{
		case 1:mciSendString(TEXT("close mysong"), NULL, 0, NULL); levelone(); break;
		case 2:mciSendString(TEXT("close mysong"), NULL, 0, NULL); leveltwo(); break;
		case 3:mciSendString(TEXT("close mysong"), NULL, 0, NULL); levelthree(); break;
		case 4:introduction(); break;
		case 5:return 0;
		}
	}
}

