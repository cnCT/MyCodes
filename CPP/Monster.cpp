#include <iostream>
#include <vector>
#include <Map>
#include <time.h>
using namespace std;

const int xCount = 9;
const int yCount = 9;
void printMap(int Map[xCount][yCount]);

class Vec2
{
private:
public:
	int x,y;
	Vec2(){};
	Vec2(int x,int y):x(x),y(y){}
	~Vec2(){}
	void toString() const
	{
		cout<<"Point(x:"<<x<<", y:"<<y<<")"<<endl;
	}
};

std::vector<Vec2> points;

int Map[xCount][yCount] = {
							{0,0,5,5,5,5,5,0,0},
							{4,0,5,5,6,5,6,0,3},
							{3,2,5,5,5,5,5,2,1},
							{3,2,4,5,4,5,1,2,2},
							{2,3,4,5,3,4,1,4,5},
							{3,6,4,1,4,5,6,3,6},
							{6,6,3,5,3,4,1,6,3},
							{6,0,3,2,1,6,4,0,6},
							{0,0,2,6,4,4,5,0,0},
						};
int hMap[xCount][yCount];

void printMap(int Map[xCount][yCount])
{
	for (int i = 0; i < xCount; ++i)
	{
		for (int j = 0; j < yCount; ++j)
		{
			cout<<Map[i][j]<<"\t";
		}
		cout<<endl;
	}
}

template <typename T>
void printT(T t)
{
	for (auto point:t)
	{
		point.toString();
	}
}

enum Priority{ 
	THREE = 1,
	FOUR = 1<<1,
	CROSS = 1<<2,
	FIVE = 1<<3
};

using PVector = std::vector<Vec2>;
using PMap = std::map<int, PVector>;

struct WTF
{
	unsigned int p;
	Vec2 centre;
	PVector vecX;
	PVector vecY;

	WTF(){}

	void toString()
	{	
		cout<<"----Start "<<p<<"----"<<endl;
		cout<<"Centre is ";
		centre.toString();
		cout<<"ListX is --------"<<endl;
		printT<PVector>(vecX);
		cout<<"ListY is --------"<<endl;
		printT<PVector>(vecY);
		cout<<"------END-------"<<endl;
	}
};

using Nodes = std::vector<WTF>;
Nodes nodes;

void threes(const Vec2 &point)
{
	point.toString();
	int l,f,u,d;
	l = f = point.x;
	u = d = point.y;
	PVector tmpX;
	PVector tmpY;
	WTF node;
	node.centre = point;
	int countX = 0;
	while(--l > 0)
	{
		if (Map[l][point.y] == Map[point.x][point.y])
		{
			cout<<l<<" l "<<point.y<<endl;
			tmpX.push_back(Vec2(l,point.y));
			++countX;
		}
		else
			break;
	};
	while(++f < xCount)
	{
		if (Map[f][point.y] == Map[point.x][point.y])
		{
			cout<<f<<" f "<<point.y<<endl;
			tmpX.push_back(Vec2(f,point.y));
			++countX;
		}
		else
			break;
	};
	if (countX>=2)
	{
		cout<<"X is THREE"<<endl;
		node.vecX = tmpX;
	}

	int countY = 0;
	while(--u > 0)
	{
		if (Map[point.x][u] == Map[point.x][point.y])
		{
			cout<<point.x<<" u "<<u<<endl;
			tmpY.push_back(Vec2(point.x,u));
			++countY;
		}
		else
			break;
	};
	while(++d < yCount)
	{
		if (Map[point.x][d] == Map[point.x][point.y])
		{
			cout<<point.x<<" d "<<d<<endl;
			tmpY.push_back(Vec2(point.x,d));
			++countY;
		}
		else
			break;
	};
	if (countY>=2)
	{
		cout<<"Y is THREE"<<endl;
		node.vecY = tmpY;
	}
	bool cross = countX>=2&&countY>=2;
	bool five = countX>=4||countY>=4;
	bool four = countX>=3||countY>=3;
	bool three = countX>=2||countY>=2;
	node.p = 0;
	if (countX>=2&&countY>=2)
	{
		node.p |= CROSS;
	}
	if (countX>=4||countY>=4)
	{
		node.p |= FIVE;	
	}
	else if (countX>=3||countY>=3)
	{
		node.p |= FOUR;	
	}
	else if (countX>=2||countY>=2)
	{
		node.p |= THREE;		
	}
	if (node.p!=0)
	{
		cout<<"Yes"<<endl;
		nodes.push_back(node);
	}
}

int main(int argc, char const *argv[])
{
	clock_t start, ends;
	start=clock();
	points.push_back(Vec2(0,2));
	points.push_back(Vec2(0,3));
	printMap(Map);
	for (auto point:points)
	{
		threes(point);
	}	
	printT<Nodes>(nodes);
	// printf("%d\n", FIVE+CROSS);
	ends=clock();
	cout << "Clock is :" << (ends-start)*1.0/1000 << endl;  
	return 0;
}