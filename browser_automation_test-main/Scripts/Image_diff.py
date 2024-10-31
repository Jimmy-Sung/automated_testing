from skimage.metrics import structural_similarity
from pathlib import Path
import sys
import cv2
import argparse
from argparse import RawTextHelpFormatter
import time

parser = argparse.ArgumentParser(description='To get image different score',formatter_class=RawTextHelpFormatter)

parser.add_argument('filename',
                    metavar='file',
                    nargs='+',
                    default=None,
                    help='input two file image1, image2')

parser.add_argument('-d', '--diff',
                    action='store_true',
                    help='Show images diff for debuging')

parser.add_argument('-o', '--outpath',
                    type=str,
                    help='Save diff images')

def ImageDiff(args):

    if(len(args.filename) != 2):
        print('error: there should have exactly two file')
        sys.exit(-1)

    # check file exist or not
    fileA = Path(args.filename[0])
    if fileA.is_file() == False:
        print(args.filename[0]+' not exist!')
        sys.exit(-1)
    fileB = Path(args.filename[1])
    if fileB.is_file() == False:
        print(args.filename[1]+' not exist!')
        sys.exit(-1)

    # load the two input images
    imageA = cv2.imread(args.filename[0])
    heightA, widthA, channelsA = imageA.shape
    imageB = cv2.imread(args.filename[1])
    heightB, widthB, channelsB = imageB.shape

    if heightA != heightB or widthA != widthB:
        imageA = cv2.resize(imageA, (widthB, heightB))

    # convert the images to grayscale
    grayA = cv2.cvtColor(imageA, cv2.COLOR_BGR2GRAY)
    grayB = cv2.cvtColor(imageB, cv2.COLOR_BGR2GRAY)

    # compute the Structural Similarity Index (SSIM) between two
    # imagfes, ensuring that the difference image is returned
    (score, diff) = structural_similarity(grayA, grayB, full=True)
    diff = (diff * 255).astype("uint8")
    print(score)

    # save images
    if args.outpath:
        cv2.imwrite(args.outpath+'diff.png', diff)
        cv2.imwrite(args.outpath+'A.png', imageA)
        cv2.imwrite(args.outpath+'B.png', imageB)
    # for diff debug
    if args.diff:
        cv2.imshow("Diff",diff)
        cv2.imshow("grayA",grayA)
        cv2.imshow("grayB",grayB)
        cv2.waitKey(0)

if __name__ == '__main__':
    args = parser.parse_args()

    try:
        ImageDiff(args)
    except Exception as e:
        print(str(e))


