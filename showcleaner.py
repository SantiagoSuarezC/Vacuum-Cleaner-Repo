import sys
import pygame
import time

screen=[]
robotat=(0,0)

def arguments(s,pred):
    s=s.split("(")
    if s[0]!=pred: return []
    args=[]
    s=s[1].split(",")
    args=s[:-1]    # take all arguments but last
    args.append(s[len(s)-1].split(")")[0])
    return args

def getmovements(filename):
    f=open(filename,'r')
    moves=[]
    for line in f:
        if not line.startswith("State"):
            atoms=line.split()
            for a in atoms:
                if a.startswith("move"):
                    args=arguments(a,"move"); 
                    moves.append(args[0])
    return moves

def drawsquare(i,j,color,width):
    color=pygame.Color(color)
    inc= 1 if width==0 else 0
    pygame.draw.rect(screen,color,[j*sqsize+inc,i*sqsize+inc,sqsize-2*inc,sqsize-2*inc],width)

def drawrobot(color):
    drawsquare(robotat[0],robotat[1],pygame.Color("white"),0)
    if color!="white":
        color=pygame.Color(color)
        pygame.draw.circle(screen,color,[robotat[1]*sqsize+sqsize/2,robotat[0]*sqsize+sqsize/2],sqsize/3,0)

def makemove(m):
    global robotat
    pygame.time.wait(delay)
    if m=='u':
        inc=(-1,0)
    elif m=='d':
        inc=(1,0)
    elif m=='r':
        inc=(0,1)
    else:
        inc=(0,-1)
    drawrobot("white")
    robotat=(robotat[0]+inc[0],robotat[1]+inc[1])
    drawrobot("red")
    pygame.event.pump()
    pygame.display.flip()


#------ Main Program

winsize=700

delay=150
# Checking arguments
if len(sys.argv)!=3 and len(sys.argv)!=4:
    print("python showcleaner.py <initialGridFile> <actionsFile> <delayMilisecs>")
    exit(0)

if len(sys.argv)==4:
    delay=int(sys.argv[3])
    
# Reading grid file
file1 = open(sys.argv[1],'r')
Lines=file1.readlines()
m=len(Lines)
n=len(Lines[0])-1
sqsize=40 if n<=20 else 750/n; 
grid = [[0 for i in range(n)] for j in range(m)]
for i in range(m):
    for j in range(n):
        grid[i][j]=Lines[i][j]
        if grid[i][j]=='r':
            robotat=(i,j)
        if grid[i][j]=='g':
            goal=(i,j)
file1.close()
# Reading sequence of actions from file
moves=getmovements(sys.argv[2])

# Screen initialization
pygame.init()
screen = pygame.display.set_mode([n*sqsize,m*sqsize])
screen.fill(pygame.Color('white'))
pygame.display.set_caption('Vacuum cleaner simulator')
pygame.display.flip()

for i in range(m):
    for j in range(n):
        drawsquare(i,j,"black",1)
        color = "black" if grid[i][j]=='x' else "gray"
        drawsquare(i,j,color,0)

drawsquare(goal[0],goal[1],"red",1)
drawrobot("red")

pygame.display.flip()
for m in moves:
    makemove(m)

done=False
while not done:
    for evento in pygame.event.get():
        if evento.type == pygame.QUIT:
            done = True
pygame.quit()