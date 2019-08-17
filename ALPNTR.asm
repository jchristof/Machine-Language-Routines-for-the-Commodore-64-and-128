;Page
;90

;Name
;Aphabetize by swapping pointers

;Description
;The main alpabetizing routine does two things. First, it sets
;up a series of pointers to string in memory. Then it does
;through the pointers and performs a Shell sort, leaving the
;strings were they are, but swapping the pointers as necessary.
;A Shell sort is generally faster than the bubble sort
;used in the ALSWAP routing, but it's easier to write either if
;the fields to be sorted are the same size (which they are not in
;the example) or if pointers are used instead of an actual swap
;of the strings. (Incidentally, Shell is capitalized because it's named
;after it's inventor, Donals Shell)

;Prototype
;First, create the table of pointers:
;1. Look, character by character, through the zero-terminated strings.
;2. When a zero is found, store the address (plus one) of the location.
;3. Check the next character. If it's not zero, increment the TOTL variable
;and continue the loop.

;Next, alphabetize the strings:
;4. Set a gap variable (TOTL) initially to the number of words.
;5. Clear the FLIP variable
;6. Cut the gap in half. If there are 120 words, the starts at 60.
;7. Set a pointer (ZP) to the begining of the list of pointers.
;8. Set a second pointer (ZQ) to the begining of the list plus the gap.
;9. Load the string pointer from ZQ and store in AQ
;10. Load the second string pointer from ZQ and store in AQ.
;11. Using Y as an offset, compare the string in AP and AQ.
;12. If they're in order, skip step 13
;13. If they're not in order, swap the pointers in memory and set FLIP to a
;non-zero value.
;14. Increment both ZP and ZQ until ZQ points beyond the end of the lest.
;15. If a swap has occurred, FLIP is not zero, so loop back to step 7.
;16. If it has not, got back to step 6 while the gap is larger than zero.

;Explanation
;This is a long routine, but a good chunk of it is devoted to the 
;part that reads a file into memory from disk. The main routine
;consists of three JSRs. The first call the sections that reads a
;text file into memory, searching for spaces - or CHR$(13)s -
;and replacing them with zeros as the file is copied to memory.
;The second calls the alphabetizing routine. The thrid prints
;out the work list.

;ALPNTR itself has two primary subroutines: MAKETL 
;and ALPHAB. The first sets up the table of pointers at
;$5000-$5fff, 4096 bytes. Since each pointer needs 2 bytes,
;this is enough memrory to handle 2048 strings or words. Note
;that BUFFER holds the actual words, while POINTR hold a
;series of pointers to the workds in BUFFER.

;Based on the assumptionm that there's at least one word in
;the list, the first entry in the table is set to point to the start of
;the bugger. Next MAKETL searchs forward for zeros. When
;one is found, the next address in the bugger is saved in 
;POINTR. Each word ends with a zero bute, and the buffer itself
;ends with an additional zero. When the final zero is found, the loop ends.

;ALPHAB is the main alphabetizing routine, and it requires
;several passes. Remember, the words stay where they
;are; it's just the pointers that are being shuffled around.

;The idea of the gap is the key to the Shell sort. The gap
;stars out at half the number of total items in the list. If there 
;are 56 things to put in order, the gap is 28. Entry 1 is compared
;with endry 29, 2 is compared iwth 30, and so on. If any
;two items are out of order, they're switched.

;After the first pass, the FLIP variable is cheched. If any
;two items have changed, the gap's value remains the
;same, and the loop is repeated. If no swaps have occurred, the 
;gap is cut in half (from 28 to 14, for example). When the gap
;drops to a value less than 1, the sort is finished.

;The great advantage to using a gap is that it moves items
;quickly ofver a long distance. Image that zookeeper is the first 
;word on the list of, say 500 words, and that its rightful place in 
;the alphabetized list is last. On the first pass (gap of 250), it is
;moved 250 placed, from 1 to 251. On the next pass (gap of
;125), it jumps another 125. After just to comparisons, it has
;traveled from location 1 to location 376. In an ordinary bubble
;sort, it would take 375 comparisons - 375 passes through the
;loop - to move that far. A Shell sort of a meduim-sized list
;will almost always beat a bubble sort.

;The following program is written in reasonabley short 
;modules and should be feasy to follow. One technique worth
;noting occurs at $c069, where DBLINC calls the routine 
;INCZPZQ directly below it. The INCZPZQ routine adds 1 to
;the pointers at ZP and ZQ. Because the DBLINC (double increment)
;routine is placed above the routine that increments
;once, the routine is called twice. The end RTS first returns to 
;just past DBLINC, where the routine executes a second time, 
;afterwhich the rts returns to the place that called it.

;Routine







