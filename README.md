# Fluid-Images
Content-Aware Image Resizing Program | "Fluid Images"

In this project, we will build a primitive that is used to shrink images while minimizing the amount of “information” lost.

Concretely, suppose that you are given an image and wish to shrink its width by a given number of pixels without changing its height. The simplest strategy is simply to scale the image, but this may introduce undesirable distortions. Another option is to crop the edges of the image, but this is unacceptable if the edges contain important information.

Given an image we first compute the “energy” of each pixel, which measures how much that pixel stands out from its surroundings. This gives us a rough idea of its importance. In other words, an “unimportant” pixel blends in with its surroundings, and can thus be removed with, hopefully, the least distortion to the image.

We will shrink the width of the image by removing vertical seams from the picture. Our algorithm consists of repeatedly finding the lowest-energy vertical seam and removing it from the image. 

Credit: Project Created for Fall 2024 CSCI 0190 Assignment, Course Taught & Designed by Shriram Krishnamurthi
