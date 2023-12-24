import sys

i=0
cols=0
rows=0
for line in sys.stdin:
    j=0
    if cols==0:
      cols=len(line.strip("\n"))
    for c in line:
      if c=='r' or c=='g' or c=='x':
         print(f"cell({i},{j},{c}).") 
      j=j+1
    i=i+1
print(f"#const m={i}.")
print(f"#const n={cols}.")