# This Python script was written by pyjamasam (SeeMeCNC) forums. This is the original source:
# https://gist.githubusercontent.com/pyjamasam/7b1cc52be3647a16e075/raw/6c240c0291d91bffd4a8ed2da0826443ce875839/gistfile1.py

# In addition to Python, you will need to have matplotlib installed:
# On Debian/Ubuntu, type this: sudo apt-get install python-matplotlib
#  Other platforms, read this: https://github.com/matplotlib/matplotlib/blob/master/INSTALL

# After you install matplotlib, copy dm_surface_transform from your SD card to this directory, and then type:
# python dm_surface_analyzer.py

# That should give you a nice window with a graphical depiction of the real Z error on your printer.

# All lines below are straight from pyjamasam's source, except that I've hard-coded the location of dm_surface_transform.

# =========================================================================================================================

#Pull your dm_surface_transform file off smothie's sd card and update the path below to point to where you put 
#it on your computer
dmSurfaceTransformPath = "dm_surface_transform"

#Then you can just run the script python <scriptname.py> with no arguments.  
#I have tested this on OS X 10.11.2 and all required python modules are available.

#The numbering in the Y axis is backwards.  It should count from 1 to 7 from the top to bottom.  Presently it is reversed.

from mpl_toolkits.mplot3d import Axes3D
from matplotlib import cm
from matplotlib.patches import Circle, Arrow, PathPatch
import mpl_toolkits.mplot3d.art3d as art3d
from matplotlib.ticker import LinearLocator, FormatStrFormatter
import matplotlib.pyplot as plt

import numpy as np

fig = plt.figure(figsize=(10,10), dpi=80)
ax = fig.gca(projection='3d')

p = Circle((4, 4), 3, alpha=0.5, color = '#cccccc')
ax.add_patch(p)
art3d.pathpatch_2d_to_3d(p, z=0, zdir="z")

ar = Arrow(4,4,1,0, width=0.2, color = "green")
ax.add_patch(ar)
art3d.pathpatch_2d_to_3d(ar,z=0,zdir="z")
ax.text(5,4.1, 0, "X", color='green')

ar2 = Arrow(4,4,0,1, width=0.2, color = 'red')
ax.add_patch(ar2)
art3d.pathpatch_2d_to_3d(ar2,z=0,zdir="z")
ax.text(4.1,5, 0, "Y", color='red')


X = np.arange(1, 8, 1)
Y = np.arange(7, 0, -1)
X, Y = np.meshgrid(X, Y)

lines = [line.rstrip('\n') for line in open(dmSurfaceTransformPath)]

Z  = []
zRow = []
for line in lines:
    if line[0] == ";":
        continue
    else:
        zRow.append(float(line))
        if (len(zRow) == 7):
            Z.append(zRow)
            zRow = []

#Z = Z[::-1]

ax.set_zlim(-0.5, 0.5)
ax.set_xlim(1,7)
ax.set_ylim(1,7)

surf = ax.plot_surface(X, Y, Z, rstride=1, cstride=1, cmap=cm.coolwarm,
                       linewidth=1, antialiased=True)
                       
ax.view_init(elev=90, azim=-90)
plt.subplots_adjust(left=0, bottom=0, right=1, top=1)

plt.show()
