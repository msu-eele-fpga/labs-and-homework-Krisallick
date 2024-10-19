# Hw 7: Linux CLI Practice

# Overview
In this assignment we practiced a multitude of linux commands.

# Deliverables
### Question 1, 2, and 3
`wc -w -m -l lorem_ipsum.txt` for all three at once, and the following commands are the exact same just seperated out to show they are the same. 
<reg><img src="assets//hw7_screenshots/question_1_2_and_3.png">

### Question 4
`sort -h file-sized.txt`

<reg><img src="assets//hw7_screenshots/question_4.png">

### Question 5
`sort -h -r file-sizes.txt`
<reg><img src="assets//hw7_screenshots/question_5.png">

### Question 6
`cut -d','-f3 log.csv`
<reg><img src="assets//hw7_screenshots/question_6.png">

### Question 7
`cut -d','-f2,3 log.csv`
<reg><img src="assets//hw7_screenshots/question_7.png">

### Question 8
`cut -d','-f1,4 log.csv`
<reg><img src="assets//hw7_screenshots/question_8.png">

### Question 9 and 10
`head -3 gibberish.txt` and `tail -3 gibberish.txt`
<reg><img src="assets//hw7_screenshots/question_9_and_10.png">

### Question 11
`tail -n20 log.csv`
<reg><img src="assets//hw7_screenshots/question_11.png">

### Question 12
`grep -c and gibberish.txt`
<reg><img src="assets//hw7_screenshots/question_12.png">

### Question 13
`grep -w we gibberish.txt`
<reg><img src="assets//hw7_screenshots/question_13.png">

### Question 14
`grep -i -o -P 'to.\w+' gibberish.txt`
<reg><img src="assets//hw7_screenshots/question_14.png">

### Question 15
`grep -c FPGAs fpgas.txt`
<reg><img src="assets//hw7_screenshots/question_15.png">

### Question 16
`grep -P '.(ot)|.(ower)|.(mile)' fpgas.txt`
<reg><img src="assets//hw7_screenshots/question_16.png">

### Question 17
`grep -r -c --include=\*.vhd "^[^/]*--.*$`
<reg><img src="assets//hw7_screenshots/question_17.png">

### Question 18
`ls > output.txt` then `cat output.txt` because it wouldn't work to pipe them together.
<reg><img src="assets//hw7_screenshots/question_18.png">

### Question 19
`sudo dmesg|grep"CPU"` because nothing had "topo" within it.
<reg><img src="assets//hw7_screenshots/question_19.png">

### Question 20
`find hdl -iname '*.vhd' | wc`
<reg><img src="assets//hw7_screenshots/question_20.png">

### Question 21
`find hdl -iname '*.vhd' |grep -r -c --include =\*.vhd "^[^/]*--.*$"`
<reg><img src="assets//hw7_screenshots/question_21.png">

### Question 22
`grep -n "FPGAs" fpgas.txt`
<reg><img src="assets//hw7_screenshots/question_22.png">

### Question 23
`du -h*|sort -hr | head -n3`
<reg><img src="assets//hw7_screenshots/question_23.png">








