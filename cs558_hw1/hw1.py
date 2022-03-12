import PIL.Image as Image
import numpy
import math

def process_iamge(image, size):
    size = (size - 1) / 2
    size = int(size)
    row, col = image.shape
    row_op = row + 2 * size
    col_op = col + 2 * size
    image_op = numpy.zeros((row_op, col_op))
    for i, j in [(i, j) for i in range(row) for j in range(col)]:
        image_op[i + size][j + size] = image[i][j]
    for i, j in [(i, j) for i in range(size) for j in range(size)]:
        image_op[i][j] = image_op[size][size]
    for i, j in [(i, j) for i in range(size) for j in range(col_op - size, col_op)]:
        image_op[i][j] = image_op[size][col_op - size - 1]
    for i, j in [(i, j) for i in range(row_op - size, row_op) for j in range(size)]:
        image_op[i][j] = image_op[row_op - size - 1][size]
    for i, j in [(i, j) for i in range(row_op - size, row_op) for j in range(col_op - size, col_op)]:
        image_op[i][j] = image_op[row_op - size - 1][col_op - size - 1]
    for i, j in [(i, j) for i in range(size) for j in range(size, col_op - size)]:
        image_op[i][j] = image_op[size][j]
    for i, j in [(i, j) for i in range(row_op - size, row_op) for j in range(size, col_op - size)]:
        image_op[i][j] = image_op[row_op - size - 1][j]
    for i, j in [(i, j) for i in range(size, row_op - size) for j in range(size)]:
        image_op[i][j] = image_op[i][size]
    for i, j in [(i, j) for i in range(size, row_op - size) for j in range(col_op - size, col_op)]:
            image_op[i][j] = image_op[i][col_op - size - 1]
    return image_op


def convolute(ip, filter):
    row, col = ip.shape
    size = int(math.sqrt(filter.size))
    row = row - 2 * int((size - 1) / 2)
    col = col - 2 * int((size - 1) / 2)
    image = numpy.zeros((row, col))
    for i, j, k, l in [(i, j, k, l) for i in range(row) for j in range(col) for k in range(size) for l in range(size)]:
        image[i][j] = image[i][j] + (filter[k][l] * ip[i + k][j + l])
    return image

def main():
    image_name = input('img name: ')
    sigma = input('sigma: ')
    size = input('size: ')
    image = Image.open(image_name)
    image.show()
    im, sigma2 = image, sigma
    size_g = int(size)
    if (size_g % 2 == 0):
        size_g += 1
    sigma2 = float(sigma2)
    sum = 0
    image3 = numpy.array(im)
    filter = numpy.zeros((size_g,size_g))
    filter_n = int((size_g-1)/2)
    y, x = numpy.ogrid[float(-filter_n):float(filter_n+1),float(-filter_n):float(filter_n+1)]
    for i, j in [(i, j) for i in range(size_g) for j in range(size_g)]:
        filter[i][j] = (math.exp((-((x[0][j]**2)+(y[i][0]**2))/(2*(sigma2**2)))))*(1/(2*math.pi*(sigma2**2)))
        sum = sum + filter[i][j]
    for i, j in [(i, j) for i in range(size_g) for j in range(size_g)]:
            filter[i][j] = filter[i][j]/sum
    temp1 = Image.fromarray(convolute(process_iamge(image3, size_g), filter))
    original_image = numpy.array(temp1)
    t_im = process_iamge(original_image, 3)
    x_image = convolute(t_im, numpy.array([[-1, 0, +1], [-2, 0, +2], [-1, 0, +1]]))
    y_image = convolute(t_im, numpy.array([[+1, +2, +1], [0, 0, 0], [-1, -2, -1]]))
    row, col = original_image.shape
    orient = numpy.zeros((row, col))
    image_opr = numpy.zeros((row, col))
    for i, j in [(i, j) for i in range(row) for j in range(col)]:
        image_opr[i][j] = math.sqrt((x_image[i][j] ** 2) + (y_image[i][j] ** 2))
        if(image_opr[i][j]<80):
            image_opr[i][j]=0
        if (x_image[i][j] != 0):
            orient[i][j] = math.degrees(math.atan(y_image[i][j] / x_image[i][j]))
    im, orr = Image.fromarray(image_opr), orient
    image1 = numpy.array(im)
    p_image = process_iamge(image1, 3)
    row, col = image1.shape
    opr_image = numpy.zeros((row, col))
    for i, j in [(i, j) for i in range(row) for j in range(col)]:
        mmm = p_image[i+1][j+1]
        oij = orr[i][j]
        if(float(-30)<=oij<float(30) or float(150)<=oij<float(-150)):
            opr_image[i][j] = mmm if mmm==max(p_image[i+1][j],mmm,p_image[i+1][j+2]) else 0
        if(float(30)<=oij<float(60) or float(-150)<=oij<float(-120)):
            opr_image[i][j] = mmm if mmm==max(p_image[i+2][j],mmm,p_image[i][j+2]) else 0
        if(float(60)<=oij<float(120) or float(-120)<=oij<float(-60)):
            opr_image[i][j] = mmm if mmm==max(p_image[i][j+1],mmm,p_image[i+2][j+1]) else 0
        if(float(120)<=oij<float(150) or float(-60)<=oij<float(-30)):
            opr_image[i][j] = mmm if mmm==max(p_image[i][j],mmm,p_image[i+2][j+2]) else 0
    image = Image.fromarray(opr_image.astype(numpy.uint8))
    image.save('out.bmp')
    image.show()

main()
