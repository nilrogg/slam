import sys
import re
from math import *
from pylab import *
from time import *
import getopt

#Data for the parser

MESSAGE_NAME='\AFLASER'
SEPARATOR=" "

#Spatial configuration numbers 
X_MAX= 20
X_MIN=-40
Y_MAX= 20 
Y_MIN=-20
TILE_LARGE=0.2


########################################################
def prob_z(delta,r):
	"Inverse sensor function"
	if delta>0 and delta<(r-EPSILON):
		 mv=1.0-(delta/(r-EPSILON))**2;
	
	else:
		 mv=0.0;
 
	if r<MAX_LASER_RANGE and delta >(r-EPSILON) and delta < (r+EPSILON):
		mo=1.0 -((delta-r)/EPSILON)**2;		
	else: 
		mo=0.0;
	
	return (1.0+mo-mv)/2.0

def bresenham(x0, y0, x1, y1):
    "Bresenham's line algorithm"
    dx = abs(x1 - x0)
    dy = abs(y1 - y0)
    puntos=[];
    x, y = x0, y0
    sx = -1 if x0 > x1 else 1
    sy = -1 if y0 > y1 else 1
    if dx > dy:
        err = dx / 2.0
        while x != x1:
            puntos=puntos+ [[x,y]];
            err -= dy
            if err < 0:
                y += sy
                err += dx
            x += sx
    else:
        err = dy / 2.0
        while y != y1:
            puntos=puntos+ [[x,y]];
            err -= dx
            if err < 0:
                x += sx
                err += dy
            y += sy        
    return puntos


######################################################
args, args_list = getopt.getopt(sys.argv[1:], 'o:d:r:i:c:h', [])
args = dict(args)

help_message = '''
USAGE: mapping_main.py [-i <input>][-o <output>] [-d <resolution>] [-c <colormap>] [-r <limits>] 
resolution: large of the tiles in meters
colormap  : gray ,autumn, copper ,hot ,etc
limits    : xmin,xmax,ymin,ymax in meters
'''
if len(sys.argv)>1:
	if '-o' in args:
		filename_output = args['-o']	
	else:
		filename_output='mapa'+strftime('-%Y-%b-%d-%H_%M_%S')
	if '-d' in args:
		TILE_LARGE = float(args['-d'])
	if '-h' in args:
		print help_message
		exit()
	if '-i' in args:
		filename=args['-i'] 
	if '-c' in args:
		colormap=args['-c']
	else:
		colormap=0;
	if '-r' in args:	
		ranges=args['-r']
		ranges_num=ranges.split(',')
		X_MIN= float(ranges_num[0])
		X_MAX= float(ranges_num[1])
		Y_MIN= float(ranges_num[2])
		Y_MAX= float(ranges_num[3])
else:
	print help_message
	exit()
##############################################
GRID_L=int((Y_MAX-Y_MIN)/TILE_LARGE)
GRID_H=int((X_MAX-X_MIN)/TILE_LARGE)

X_OFFSET=int(-X_MIN/TILE_LARGE)
Y_OFFSET=int(-Y_MIN/TILE_LARGE)

GRID_X_MAX=int(X_MAX/TILE_LARGE)
GRID_X_MIN=int(X_MIN/TILE_LARGE)
GRID_Y_MAX=int(Y_MAX/TILE_LARGE)
GRID_Y_MIN=int(Y_MIN/TILE_LARGE)

#Laser characteristics

MAX_LASER_RANGE   = 80
LASER_RESOLUTION  = 1.0/180.0  
LASER_FOV	      = pi
LASER_START_ANGLE =-pi/2
EPSILON		      = 1.0;

#Ouput format
PNG='.png'
GIF='.gif'
BITS=8
NUM=2**BITS-1

#Variables
count_line=0;
cell=[0.0]*2;
grid=zeros([GRID_H,GRID_L,2]);
grid3=ones([GRID_H,GRID_L]);
##################################################
print "Processing data....."
old_time=time()

with open(filename,"r") as data:
	for line in data:
		if re.search(MESSAGE_NAME,line):	
			count_line+=1;
			fields=re.split(SEPARATOR,line)		
			count_rangos=int(fields[1])
			rangos=[0.0]*count_rangos
			x=float(fields[2+count_rangos])					
			y=float(fields[2+count_rangos+1])
			theta=float(fields[2+count_rangos+2])
			for i in range(0,count_rangos):
				rangos[i]=float(fields[2+i]);
				phi=LASER_FOV*i*LASER_RESOLUTION+LASER_START_ANGLE;							
				cell[0]= x+ rangos[i]*cos(phi+theta);
				cell[1]= y+ rangos[i]*sin(phi+theta);
				xx1=int(cell[0]/TILE_LARGE)
				yy1=int(cell[1]/TILE_LARGE)
				xx0=int(x/TILE_LARGE)
				yy0=int(y/TILE_LARGE)				
				if xx1>GRID_X_MIN and xx1<GRID_X_MAX and yy1>GRID_Y_MIN and yy1<GRID_Y_MAX:			
					puntos= bresenham(xx0,yy0,xx1,yy1);				
					Final=[xx1,yy1]
					Inicial=[xx0,yy0]					
					r=    sqrt(  (Inicial[0]-Final[0])**2 + (Inicial[1]-Final[1])**2 )*TILE_LARGE										
					if rangos[i]<MAX_LASER_RANGE:
						grid[Final[0]+X_OFFSET,Final[1]+Y_OFFSET,1]+=1;
						grid[Final[0]+X_OFFSET,Final[1]+Y_OFFSET,0]+=1;
						
						for punto in puntos:
							delta=sqrt((punto[0]-Final[0])**2+(punto[1]-Final[1])**2)*TILE_LARGE
							grid[punto[0]+X_OFFSET,punto[1]+Y_OFFSET,1]+=1;
							
						
#####################################################										
time_elapsed=(time()-old_time)
print "Procesing Finished"
print "Measured points: %d" % count_line
print "Time elapsed: %d seconds" % time_elapsed 


#Scaling for visualization
for a in range(0,GRID_H):
	for b in range (0,GRID_L):
		grid3[a,b]=grid[a,b,0]/(grid[a,b,1]+grid[a,b,0])
		if (grid[a,b,0]+grid[a,b,1])==0:
			grid3[a,b]=0.25
		#if grid3[a,b]<0.25:
		#	grid3[a,b]=0
		#elif grid3[a,b]==0.25:
		#	grid3[a,b]=0.5
		#else:
		#	grid3[a,b]=1		


mapa=NUM-(NUM*grid3)/grid3.max();

#Saving map

if   colormap =='gray' or colormap==0 :
	palette= cm.gray
elif colormap =='copper':
	palette= cm.copper
elif colormap =='hot':
	palette= cm.hot
elif colormap =='autumn':	
	palette= cm.autumn

## Draw the path of the robot
palette.set_under('r',0); 

imsave(filename_output+'.png',mapa,cmap=palette)

#Showing map
imshow(mapa,cmap=palette)
show()









