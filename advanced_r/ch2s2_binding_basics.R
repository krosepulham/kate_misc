library(lobstr)
library(dplyr)

x<-c(1,2,3)
y<-x

#both x and y are pointers (?) to the same memory address, which has the value
#c(1,2,3) stored:
obj_addr(x)
obj_addr(y)

#these addresses don't just change every time you restart R, they change even if
#you just run the same lines again:
x<-c(1,2,3)
y<-x
obj_addr(x)
obj_addr(y)

#some words are reserved in R, for a complete list:
?reserved

#"A syntactic name must consist of letters, digits, . and _ but can't begin with
#_ or a digit. Additionally, you can't use any of the reserved words"
#so these lines produce errors:
  #_abc <- 1
  #if <- 10
#if we need the name to be like this for some reason, backticks can make it 
#happen:
`_abc` <- 1
`if`  <- 10
#but they must be called with the backticks as well:
`_abc`
`if`

#2.2.2: Excercises

#1. Explain the relationship between a, b, c and d in the following code:
a <- 1:10
b <- a
c <- b
d <- 1:10
#Answer: a,b,c and d are all names for vectors that have the same value: 1:10
#a,b, and c have the same memory address while d has a different memory address
obj_addr(a)
obj_addr(b)
obj_addr(c)
obj_addr(d)

#2. The following code accesses the mean function in multiple ways. Do they all 
#point to the same underlying function object? Verify this with 
#lobstr::obj_addr().
mean
base::mean
get("mean")
evalq(mean)
match.fun("mean")
#answer: I'm actually not sure on this one. based on running the lines, it looks
#like they are, since they have the same bytecode and environment. let's check
a<-obj_addr(mean)
b<-obj_addr(base::mean)
c<-obj_addr(get("mean"))
d<-obj_addr(evalq(mean))
e<-obj_addr(match.fun("mean"))
c(a,b,c,d,e)
#looks like they are the same memory address, which makes sense since all 5 are 
#the same function: the mean. 

#3. By default, base R data import functions, like read.csv(), will 
#automatically convert non-syntactic names to syntactic ones. Why might this be 
#problematic? What option allows you to suppress this behaviour?

#Answer: any time we do something "automatically" we're opening up the door for
#circumstances which we cannot anticipate to ruin our day. I can see how this 
#might unintentionally give two vectors the same name, which causes us to lose
#the first vector. this behavior can be suppressed by setting check.names=TRUE,
#but doing this means we could potentially get errors from syntactically invalid
#names. from the documentation for make.names, we can see that my intuition 
#about duplicate names is true:
make.names(c("_blah","X_blah"))
#however, closer inspection of the documentation shows that if there are 
#duplicates, make.unique is used to rename them to make sure they're unique:
make.names(c("_blah","X_blah"))%>%
  make.unique()

#4. What rules does make.names() use to convert non-syntactic names into 
#syntactic ones
?make.names
#Answer: I actually investigated this a bit for problem 3. 
#The documentation shows:
  #The character "X" is prepended if necessary. All invalid characters are 
  #translated to ".". A missing value is translated to "NA". Names which match R 
  #keywords have a dot appended to them. Duplicated values are altered by 
  #make.unique.

#5. I [Hadley] slightly simplified the rules that govern syntactic names. Why is 
#.123e1 not a syntactic name? Read ?make.names for the full details.
?make.names
#Answer: From the documentation:
  #A syntactically valid name consists of letters, numbers and the dot or 
  #underline characters and starts with a letter or the dot not followed by a 
  #number. Names such as ".2way" are not valid, and neither are the reserved 
  #words.
#so the reason this isn't syntactically valid is that it starts with a period,
#immediately followed by a number.
