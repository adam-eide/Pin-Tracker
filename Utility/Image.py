import PIL
from PIL import Image
import sys
import os

def main():
	process(["", "2008_7_full.png", "4"])
	process(["", "2008_8_full.png", "3"])
	process(["", "2008_9_full.png", "4"])
	process(["", "2008_10_full.png", "4"])
	process(["", "2008_11_full.png", "4"])
	process(["", "2008_12_full.png", "4"])
	process(["", "2008_13_full.png", "4"])
	process(["", "2008_14_full.png", "4"])
	process(["", "2008_15_full.png", "4"])
	process(["", "2008_16_full.png", "4"])
	process(["", "2008_17_full.png", "4", "2", "2"])
	process(["", "2008_18_full.png", "4", "2", "2"])
	process(["", "2008_19_full.png", "10"])

def process(ar):
	print("Hi")
	final_width = 5
	arg = ar[1]
	frames = int(ar[2])
	combine = False
	if (len(ar) >= 4):
		if ar[3] == "+join":
			combine = True
			f_wide = frames;
			f_high = 1;
		else:
			f_wide = int(ar[3])
			f_high = int(ar[4])
	else:
		f_wide = frames;
		f_high = 1;

	year = arg.split("_")[0]
	series = arg.split("_")[1]
	path = "pics/{}_{}_full.png".format(year, series)
	try:
		image = Image.open(path)
	except IOError:
		print("Unable to load image1")
		sys.exit(1)

	if combine:
		path2 = "pics/{}_{}_full2.png".format(year, series)
		try:
			image2 = Image.open(path2)
		except IOError:
			print("Unable to load image2")
			sys.exit(1)
		w = image.width
		h = image.height
		image = image.crop((0,0, w + image2.width, image.height))
		image.paste(image2, (w, 0))
		os.remove(path2)

	w = image.width
	h = image.height

	if f_high > 1:
		box_h = int(h / f_high)
		box_w = int(w / f_wide)
		image = image.crop((0,0,frames*box_w, h))
		row = 0
		col = 0
		for i in range(0, frames):
			next_f = image.crop((col * box_w, row * box_h, col * box_w + box_w, row * box_h + box_h))
			image.paste(next_f, (i * box_w, 0))
			col += 1
			if col % f_wide == 0:
				row+=1
				col = 0

		image = image.crop((0,0,box_w*frames, box_h))
	w = image.width
	h = image.height
	unit_width = int(w / frames)
	for i in range(0, frames):
		new = image.crop((i * unit_width, 0, i*unit_width + unit_width, h))
		new.save("pics/{}_{}_{}.png".format(year, series, i+1))
	big = image.crop((0,0,unit_width*final_width,h))
	if h > 120:
		scale = 120.0 / h
		new_big = big.resize((int(scale * big.width), 120))
	big.save("pics/{}_{}_full.png".format(year, series))

	
main()