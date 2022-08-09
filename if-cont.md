**Simple if statement**

```bash
if <expression for checking>;then
   <set of commands to be executed>
fi
```

**If-Else condition**

```bash
if <expression for checking>;
then
<set of commands to be executed>
else
<set of other commands to be executed>
fi
```

**If elif else fi statement**

```bash
if <expression 1 for checking>;
then
<set of commands to be executed>
.
.
elif <expression 2 for checking>
then
<set of other commands to be executed>
.
.
else
<set of else set of commands to be executed>
fi
```

**If then else … if then … fi**

```bash
if <expression 1 for checking>;
then
<set of commands to be executed>
.
.
else
if <expression 1 for checking>;
then
<set of commands to be executed>
.
.
fi
fi
```

| Operation |	What does it mean? |
|---|---|
|! <Expression>	| Expression is false|
|-n <String 1>	| The string length should be greater than 0 |
|-z <String 1>	| The string length is 0; or in other words, it is an empty string|
|String A = |String B	String A and String B are equal|
|String A != |String B	String A and B are not equal|
|Integer 1-eq |Integer 2	Integer 1 is equal to Integer 2; Numerically|
|Integer 1-gt |Integer 2	Integer 1 is less than Integer 2; Numerically|
|Integer 1-lt |Integer 2	Integer 1 is less than Integer 2; Numerically|
|-d <File>	|To check if the <File> mentioned is present and if it is a directory|
|-d <File>	|To check if the <File> exists|
|-d <File>	|To check if <File> exists and has the permission granted for reading|
|-d <File>	|If the <File> exists and has a file size greater than 0|
|-d <File>	|Checks if the <File> exist and has permission granted for write|
|-d <File>	|Checks if the <File> exist and has permission granted for execute|


