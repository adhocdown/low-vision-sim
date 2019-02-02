# -*- coding: utf-8 -*-
"""
Created on Sun Mar  4 14:19:59 2018

Input data: 
    A 9x8 matrix of integer values from a Humphrey Field Analyzer Test. 
    No digital records were given, so numbers were transcribed by hand into a text document.
    Where no value was given, a 99 was inserted as a buffer (dummy) value.
    
    Note: the current script only views the first matrix in the text document. 
    Therefore, if multiple matrices of data are presented, then only the first is recorded.
    
Method:
    1. Read in data from HVFAData folder
    2. Fill in empty data
    3. Convert from log to linear scale
    4. Convert to grayscale intensity map

Output:
    A grayscale intensity map! 

@author: Haley Adams (adhocdown)
"""

import math
import numpy as np
from matplotlib import pyplot as plt


def main():
    BUFFER = 99; 
    foldername = 'HVFAData'
    
    # asign filename 
    #filename = input("enter filename: ") 
    eye = "left" #left or right 
    filename = 'bitemporal_loss'
    #filename = 'central_scotoma'           
    #filename = 'homonymous_hemianopia'    
    #filename = 'homonymous_hemianopia_complete'  

    inputfile = open(foldername+'/'+filename + '.txt.');
    WIDTH, HEIGHT = get_matrix_size(inputfile);
    
    # extend deficit to fit full screen (oculus)
    inputfile.seek(0)
    
    # Read in logarithmic scale light sensitiviy values
    log_list = read_log_data(inputfile, WIDTH, HEIGHT, BUFFER)   
    #print(log_list)
    
    # Interpolate average nearest neighbor values to fill in empty data (where value = BUFFER)
    fill_corners(log_list, WIDTH, HEIGHT)
    #print(log_list)    
    
    # Convert values to a linear scale 
    linear_list = convert_to_linear(log_list, WIDTH, HEIGHT)
    #print(linear_list)
    
    # Render a grayscale map to be used as an image shader in Unity
    make_grayscale_image_oculus(linear_list, WIDTH, HEIGHT, filename, eye)    

    
    

#############################   FUNCTIONS   #############################
    
# Turn array of floats into a grayscale image 
def make_grayscale_image_oculus(img_matrix, W, H, filename, eye):
    SCREEN_W , SCREEN_H = 1080, 1200
    FOV_X, FOV_Y = 84, 93
    x_pixel_count =  math.floor(SCREEN_W * (60 / FOV_X))
    y_pixel_count =  math.floor(SCREEN_H  * (60 / FOV_Y))
    
    x_scale = FOV_X / 60  
    y_scale = FOV_Y / 60 
    Xsize = math.floor(x_pixel_count / 10)
    Ysize = math.floor(y_pixel_count / 10)
    
    print("pixelcnt:  " + str(x_pixel_count) + ", " + str(y_pixel_count))
    print("scale:  " + str(x_scale) + ", " +  str(y_scale))
    print("size img:  " + str(Xsize) + ", " +  str(Ysize))    
    
    #figsize is in inches and dpi is pixels per inch
    fig = plt.figure(frameon=False, figsize=(Xsize, Ysize), dpi = 10) 
    
    ax = plt.Axes(fig, [0., 0., 1., 1.])
    ax.set_axis_off()
    fig.add_axes(ax)
    
    # potential interpolation modes: 
    # https://matplotlib.org/examples/images_contours_and_fields/interpolation_methods.html
    # none, nearest, bilinear, bicubic, spline16, spline36, hanning, hamming, hermite,
    # kaiser, quadric, catrom, gaussian, bessel, mitchel, sinc, lanczos
    ax.imshow(img_matrix, cmap=plt.cm.binary, aspect='auto', interpolation='gaussian')
    fig.savefig(filename +'_'+ eye + '.png') 
    #fig.savefig(filename + '_left_clamp30_gaussian.png') 

    
    plt.show()
    plt.close()    
    return 
    
    
# Takes input log vals and converts them to a linear scale
def convert_to_linear(log_list, WIDTH, HEIGHT): 
    linear_list = np.array( [[0 for x in range(WIDTH)] for y in range(HEIGHT)] )
    linear_val = 0

    for row in range(HEIGHT):
        for col in range(WIDTH):
            num = float(log_list[row][col])

            # LINEAR
            if (num >= 30): num = 30
            ##ration/percentage - calc cur val / max potential val 
            #linear_val = (math.pow(10, num/30)) / math.pow(10, 30/30) 
            linear_val = math.pow(10, num/30) / 10          
            linear_list[row][col] = math.floor(linear_val*255)

            # test log linear conversion output  
            #print(log_list[row][col], " => ", linear_val)
    return linear_list


# Interpolate average nearest neighbor values to fill in empty data (where value = BUFFER)
def fill_corners(img, w, h):
    middleX = math.floor(w/2) 
    middleY = math.floor(h/2) 
    endX = w-middleX;
    endY = h-middleY;
    img = np.transpose(img)
    
    
    # NOTE: ORIGIN = TOP LEFT
    #top left quadrant    
    origin = (middleX-1, middleY-1)
    for i in range(0, middleX):
        for j in range(0, middleY):
            num = img[origin[0]-i][origin[1]-j] 
            if (num == 99):
                val_list = np.array([img[origin[0]-i+1][origin[1]-j], img[origin[0]-i][origin[1]-j+1], img[origin[0]-i+1][origin[1]-j+1] ])
                img[origin[0]-i][origin[1]-j] = np.mean(val_list)
                #print(np.mean(val_list))                
            #print(str(origin[0]-i) + ", " + str(origin[1]-j) + " = " + str(img[origin[0]- i ][origin[1] - j]) )        
    
    #top right quadrant
    origin = (middleX, middleY - 1)
    for i in range(0, endX):
        for j in range(0, middleY):
            num = img[origin[0]+i][origin[1]-j] 
            if (num == 99):
                val_list = np.array([img[origin[0]+i-1][origin[1]-j], img[origin[0]+i][origin[1]-j+1], img[origin[0]+i-1][origin[1]-j+1] ])
                img[origin[0]+i][origin[1]-j]  = np.mean(val_list) 
                #print(str(origin[0]+i) + ", " + str(origin[1]-j) + " = " + str(img[origin[0]+i][origin[1]-j] ) )        
                #print(np.mean(val_list))       
    
    #bottom left quadrant
    origin = (middleX - 1, middleY)
    for i in range(0, middleX): 
        for j in range(0, endY): 
            num = img[origin[0]-i][origin[1]+j] 
            if (num == 99):
                val_list = np.array([img[origin[0]-i+1][origin[1]+j], img[origin[0]-i][origin[1]+j-1], img[origin[0]-i+1][origin[1]+j-1] ])
                img[origin[0]-i][origin[1]+j] = np.mean(val_list)               
                #print(str(origin[0]-i) + ", " + str(origin[1]+j) + " = " + str(img[origin[0]-i][origin[1]+j] ) )                        
    
    #bottom right quadrant
    origin = (middleX, middleY)
    for i in range(0, endX):
        for j in range(0, endY):
            num = img[origin[0]+i][origin[1]+j] 
            if (num == 99):
                val_list = np.array([img[origin[0]+i-1][origin[1]+j], img[origin[0]+i][origin[1]+j-1], img[origin[0]+i-1][origin[1]+j-1] ])
                img[origin[0]+i][origin[1]+j]  = np.mean(val_list)    
                #print(str(origin[0]+i) + ", " + str(origin[1]+j) + " = " + str(img[origin[0]+i][origin[1]+j] ) )        



# Create an matrix of dB vals (logarithmic scale)
# Size depends on patient data, so determine size as you parse
# Currently handles one eye at a time. Should automate for both later.
def read_log_data(file, w, h, buffer):
    
    log_list = np.array( [[buffer for x in range(w)] for y in range(h)] )
    found_number_data = False
    row = 0

    for line in file:
        if (line.isspace()): continue;
        if (line[0].isalpha()):
            if(found_number_data == False): continue;
            else: break;
        else:
            found_number_data = True
            temp = line.split(', ')
            temp[-1] = temp[-1].strip()
            #print (temp)
            log_list[row][0] = buffer
            for index, val in enumerate(temp):
                #print(index, val)
                log_list[row][index] = val;                
            temp[-1] = temp[-1].strip()
            row += 1
            
    #print(log_list)
    return log_list    



# Skip info until numerical data is found
# Count data. Determine width and height of image matrix
def get_matrix_size(file):
    width, height = 0,0
    found_number_data = False
    for line in file:
        if (line.isspace()): continue;
        if (line[0].isalpha()):
            if(found_number_data == False): continue;
            else: break;
        else:
            found_number_data = True
            temp = line.split(', ')
            height += 1    

    width = len(temp)
    #print( "matrix size: " + str(width) + ", " + str(height)) 
    return width, height;



main()
    
