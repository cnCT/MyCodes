#include <cstdlib>
#include <iostream>
#include <vector>
#include <cstdio>
#include <ctime>
#include <Map>
using namespace std;

#define Random(x,y) (rand()%(y-x+1)+x)
#define MAX(x,y) (x>y?x:y)
const int xCount = 9,yCount = 9;

class Vec2 {
	private:

	public:
		int x,y;
		Vec2() {}
		Vec2(int _x,int _y):x(_x),y(_y) {}
		void toString() {
			printf("Point(%d, %d)\n",x,y);
		}
};

using PVec = std::vector<Vec2>;
using PMap = std::map<int, PVec>;

enum class PRIORITY {
    THREE,
    FOUR,
    CROSS,
    FIVE
};

struct Node {
	PRIORITY Priority;
	PMap pointsX;
	PMap pointsY;
	Vec2 Cross;
	Node() {
	}
	~Node() {
	}
};

using Nodes = std::vector<Node>;
Nodes unProcessedNode;

int Map[xCount][yCount] = {
	{1,5,3,1,3,6,1,4,2},
	{2,4,4,4,4,4,1,4,1},
	{4,4,2,6,4,2,2,4,5},
	{5,4,4,4,4,1,5,5,4},
	{1,3,3,4,6,2,1,1,1},
	{5,2,3,4,2,5,5,3,2},
	{4,1,3,4,5,5,1,4,2},
	{4,5,3,3,3,4,5,5,3},
	{2,6,2,3,5,4,2,2,3}
};

PVec points;

using namespace std;

void initRandom() {
	srand((int)time(0));
}

void printMap() {
	for(int i=0; i<xCount; ++i) {
		for(int j=0; j<yCount; j++) {
			cout<<Map[i][j]<<"\t";
		}
		cout<<endl;
	}
}

void initMap(int num) {
	for(int i=0; i<xCount; ++i) {
		for(int j=0; j<yCount; j++) {
			Map[i][j] = num;
		}
	}
}

PVec pointX;
PVec pointY;

void threes(Vec2 point) {
	int u,d,l,r;
	u = d = point.x;
	l = r = point.y;
	auto value = Map[point.x][point.y];
	PVec tmpPointsX;
	PVec tmpPointsY;

	while(--l>0) {
		if(Map[point.x][l]==value) {
//			cout<<point.x<<" L "<<l<<endl;
			tmpPointsX.push_back(Vec2(point.x,l));
		} else {
			break;
		}
	}

	while(++r<yCount) {
		if(Map[point.x][r]==value) {
//			cout<<point.x<<" R "<<r<<endl;
			tmpPointsX.push_back(Vec2(point.x,r));
		} else {
			break;
		}
	}
	if(tmpPointsX.size()>=2) {
		cout<<"X Threes "<<endl;
	}

	while(--d>0) {
		if(Map[d][point.y]==value) {
//			cout<<d<<" D "<<point.y<<endl;
			tmpPointsY.push_back(Vec2(d,point.y));
		} else {
			break;
		}
	}

	while(++u<yCount) {
		if(Map[u][point.y]==value) {
//			cout<<u<<" U "<<point.y<<endl;
			tmpPointsY.push_back(Vec2(u,point.y));
		} else {
			break;
		}
	}
	if(tmpPointsY.size()>=2) {
//		cout<<"Y Threes "<<endl;
	}

	Node node;
	auto countX = tmpPointsX.size();
	auto countY = tmpPointsY.size();
	auto flag = true;
	if(MAX(countX,countY)>=4) {
		node.Priority = PRIORITY::FIVE;
		node.pointsX[point.x] = tmpPointsX;
		node.pointsY[point.y] = tmpPointsY;
	} else if(countX>=2&&countY>=2) {
		node.Priority = PRIORITY::CROSS;
		node.pointsX[point.x] = tmpPointsX;
		node.pointsY[point.y] = tmpPointsY;
	} else if(countX>=2) {
		node.Priority = PRIORITY::THREE;
		node.pointsX[point.x] = tmpPointsX;
	} else if(countY>=2) {
		node.Priority = PRIORITY::THREE;
		node.pointsY[point.y] = tmpPointsY;
	} else {
		flag = false;
	}

	if(flag) {
		node.Cross = point;
		unProcessedNode.push_back(node);
	}
}

void process(Nodes nodeVec) {
	for(auto node:nodeVec) {
		
	}
}

void test_points() {
	initMap(1);
	PVec testPoint;
	for(int i=0; i<xCount; ++i) {
		for(int j=0; j<yCount; j++) {
			testPoint.push_back(Vec2(i,j));
		}
	}

	for(auto p:testPoint) {
//			p.toString();
		threes(p);
	}
}

int main(int argc, char *argv[]) {
	initRandom();
	test_points();
	printMap();

	points.push_back(Vec2(1,1));
	points.push_back(Vec2(1,2));
	
	
//	for(auto p:points) {
////			p.toString();
//		threes(p);
//	}

	return EXIT_SUCCESS;
}
