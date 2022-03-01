"
I'm is a test class for testing the behavior of MicCodeBlock


For now we do not support the use of multiple backticks. 

If you want to embed codeblock inside codeblock you must use an extra space. 

```
 ```
 A nested codeblock
 ```
```
"
Class {
	#name : #MicCodeBlockTest,
	#superclass : #MicBlockTest,
	#category : #'Microdown-Tests-Parser'
}

{ #category : #tests }
MicCodeBlockTest >> testBody [
	| source root textBody |
	textBody := 'my fancy code
is really cool'.
	source := CodeblockMarkup, String cr, textBody, String cr, CodeblockMarkup. 
	root := parser parse: source.
	self assert: root children first body equals: textBody.
	
]

{ #category : #tests }
MicCodeBlockTest >> testCanConsumeLine [ 
	"This test verfies that when a code block is closed it does not consume anymore."
	"It also show that consume is not just blindly do a line starts with the markup 
	since often the first line is consumed by the parent of the block."
	
	| source root textBody argument |
	textBody := 'my fancy code
is really cool'.
	argument := 'ArgumentGoesHere'.
	source := CodeblockMarkup, argument, String cr, textBody, String cr, CodeblockMarkup. 
	root := parser parse: source.
	
	"An already created blockNode cannot consume a new code block since no nesting is allowed."
	self deny: (root children first canConsumeLine: '```language=zork').
	
	"An already closed blockNode cannot consume even plain text"
	self deny: (root children first canConsumeLine: 'plain text')
]

{ #category : #'tests - code' }
MicCodeBlockTest >> testCaption [

	| codeBlock |
	codeBlock := self testedClass new.
	codeBlock caption: '**Here** is a nice caption.'.
	self assert: codeBlock hasCaption. 
	self assert: codeBlock captionElements first class equals: MicBoldFormatBlock.
	self assert: codeBlock captionElements size equals: 2.
]

{ #category : #tests }
MicCodeBlockTest >> testCodeBlockWithNestedCodeBlock [
	"This test shows that we can write a code block inside a code block but that the later is not interpreter."
	
	| source root code textBody |
	textBody := ' ``` 
 my fancy code
 is really cool
 ```'.
	source := CodeblockMarkup,  String cr, textBody, String cr, CodeblockMarkup. 
	root := parser parse: source.
	
	self 
		assert: root children size 
		equals: 1.
	code := root children first.
	self assert: code children isEmpty.
	self
		assert: code code
		equals: textBody.
	
]

{ #category : #'tests - code' }
MicCodeBlockTest >> testCodeCreatesInnerText [

	| code |
	code := (self parser parse: '```a b```') children first.
	self assert: code class equals: MicCodeBlock.
	self assert: (code arguments at: #language) equals: 'a b```'
]

{ #category : #'tests - first tag' }
MicCodeBlockTest >> testFirstTagNoValue [

	"
	```language&caption=Getting a morph for an instance of ==Color==&label=scr:asMorphInColor
Color >> asMorph
    ^ Morph new color: self
	```
	"
	| source root code  textBody argument |
	textBody := 'Color >> asMorph
    ^ Morph new color: self'.
	argument := 'Method'.
	source := CodeblockMarkup, argument, String cr, textBody, String cr, CodeblockMarkup. 
	root := self parser parse: source.
	self assert: root children size equals: 1.
	code := root children first.
	self assert: (code arguments at:#language) equals: 'Method'
]

{ #category : #'tests - first tag' }
MicCodeBlockTest >> testFirstTagValue [

	| source codeBlock |
	source := CodeblockMarkup, 'language=12', String cr, 'Color >> asMorph
    ^ Morph new color: self' , String cr, CodeblockMarkup. 
   codeBlock := (self parser parse: source) children first.
	self assert:  (codeBlock language)  equals: '12'.
]

{ #category : #'tests - first tag' }
MicCodeBlockTest >> testFirstTagWithValue [

	"
	```language=pharo&caption=Getting a morph for an instance of ==Color==&label=scr:asMorphInColor
Color >> asMorph
    ^ Morph new color: self
	```
	"
	| source root code  textBody argument |
	textBody := 'Color >> asMorph
    ^ Morph new color: self'.
	argument := 'language=PharoMethod'.
	source := CodeblockMarkup, argument, String cr, textBody, String cr, CodeblockMarkup. 
	root := self parser parse: source.
	self assert: root children size equals: 1.
	code := root children first.
	self assert: (code arguments at:#language) equals: 'PharoMethod'
]

{ #category : #'tests - deviation' }
MicCodeBlockTest >> testFourBackQuotes [

	| codeBlock |
	codeBlock := parser parse: '```` 
something in the way
````'.

	self assert: codeBlock children first body equals: 'something in the way'
]

{ #category : #'tests - deviation' }
MicCodeBlockTest >> testFourBackQuotesClosedByThreeQuotes [

	| codeBlock |
	codeBlock := parser parse: '```` 
something in the way
```'.

	self assert: codeBlock children first body equals: 'something in the way'
]

{ #category : #'tests - deviation' }
MicCodeBlockTest >> testFourBackQuotesOnMultipleLines [

	| codeBlock |
	codeBlock := parser parse: '````pharo
something in the way
pif
glop or pas glop
````'.

	self assert: codeBlock children first body equals: 'something in the way
pif
glop or pas glop'
]

{ #category : #'tests - deviation' }
MicCodeBlockTest >> testFourBackQuotesOnMultipleLinesWithText [

	| codeBlock |
	codeBlock := parser parse: '
Before	
	
	
````pharo
something in the way
pif
glop or pas glop
````
After
'.

	self assert: codeBlock children second body equals: 'something in the way
pif
glop or pas glop'
]

{ #category : #'tests - deviation' }
MicCodeBlockTest >> testFourBackQuotesWithTextAround [

	| codeBlock |
	codeBlock := parser parse: '
Start text here
	
```` 
something in the way
````

Ending text'.

	self assert: codeBlock children second body equals: 'something in the way'
]

{ #category : #'tests - code' }
MicCodeBlockTest >> testHasBody [

	| source root textBody |
	textBody := 'this is my body'.
	source := CodeblockMarkup , String cr , textBody , String cr, CodeblockMarkup.
	root := parser parse: source.
	self assert: root children first hasBody
]

{ #category : #'tests - code' }
MicCodeBlockTest >> testHasBody_not [

	| source root textBody |
	textBody := ''.
	source := CodeblockMarkup , String cr , textBody , String cr, CodeblockMarkup.
	root := parser parse: source.
	self assert: root children first hasBody not
]

{ #category : #tests }
MicCodeBlockTest >> testHasCaption [

	"
	```language=pharo&caption=Getting a morph for an instance of ==Color==&label=scr:asMorphInColor
Color >> asMorph
    ^ Morph new color: self
	```
	"
	| source root code  textBody argument |
	textBody := 'Color >> asMorph
    ^ Morph new color: self'.
	argument := 'language=pharo&caption=Getting a morph for an instance of ==Color==&label=scr:asMorphInColor'.
	source := CodeblockMarkup, argument, String cr, textBody, String cr, CodeblockMarkup. 
	root := self parser parse: source.
	
	code := root children first.
	self assert: code hasCaption
]

{ #category : #'tests - arguments' }
MicCodeBlockTest >> testHasLabelFalse [
	"
	```language=pharo&caption=Getting a morph for an instance of ==Color==&label=scr:asMorphInColor
Color >> asMorph
    ^ Morph new color: self
	```
	"
	| source code |
	source := CodeblockMarkup, 'language=pharo&caption=`Color` is a class.', String cr, 'Color >> asMorph
    ^ Morph new color: self', String cr, CodeblockMarkup. 

	code := (self parser parse: source) children first.
	self deny: code hasLabel
]

{ #category : #'tests - arguments' }
MicCodeBlockTest >> testHasLabelTrue [
	"
	```language=pharo&caption=Getting a morph for an instance of ==Color==&label=scr:asMorphInColor
Color >> asMorph
    ^ Morph new color: self
	```
	"
	| source code |
	source := CodeblockMarkup, 'language=pharo&caption=`Color` is a class.&label=scr:asMorphInColor', String cr, 'Color >> asMorph
    ^ Morph new color: self', String cr, CodeblockMarkup. 

	code := (self parser parse: source) children first.
	self assert: code hasLabel
]

{ #category : #tests }
MicCodeBlockTest >> testHasNOCaption [
	"
	```language=pharo&caption=Getting a morph for an instance of ==Color==&label=scr:asMorphInColor
Color >> asMorph
    ^ Morph new color: self
	```
	"
	| source root code  textBody argument |
	textBody := 'Color >> asMorph
    ^ Morph new color: self'.
	argument := 'language=pharo&label=scr:asMorphInColor'.
	source := CodeblockMarkup, argument, String cr, textBody, String cr, CodeblockMarkup. 
	root := self parser parse: source.
	
	code := root children first.
	self deny: code hasCaption
]

{ #category : #'tests - arguments' }
MicCodeBlockTest >> testLanguage [

	"
	```language=pharo&caption=Getting a morph for an instance of ==Color==&label=scr:asMorphInColor
Color >> asMorph
    ^ Morph new color: self
	```
	"
	| source code |
	source := CodeblockMarkup, 'language=pharo&caption=`Color` is a class.&label=scr:asMorphInColor', String cr, 'Color >> asMorph
    ^ Morph new color: self', String cr, CodeblockMarkup. 

	code := (self parser parse: source) children first.
	self assert: code language equals: 'pharo'
]

{ #category : #tests }
MicCodeBlockTest >> testOpenCanConsumeLine [
	| source root textBody argument line code |
	
	"ready for code factory"
	textBody := 'my fancy code
is really cool'.
	argument := 'ArgumentGoesHere'.
	source := (CodeblockMarkup, argument, String cr, textBody, String cr, CodeblockMarkup) readStream. 
	
	line := source nextLine.
	
	"parsing an empty line make sure that we get the root block node"
	root := parser parse: ''.
	self assert: parser current equals: root.
	
	"now the root block can consume ```xxxx"
	self assert: (root canConsumeLine: line).
	"now we get back an open code block"
	code := parser handleLine: line.
	self assert: code parent equals: root.
	self deny: code isClosed. 
	
	"now new line"
	line := source nextLine.
	self assert: (code canConsumeLine: line). 
	self assert: (code canConsumeLine: CodeblockMarkup).
	"now a code block is closed."
	self deny: (code canConsumeLine: line). 
	self assert: code isClosed
	
	
	
]

{ #category : #'tests - code' }
MicCodeBlockTest >> testSetLabel [

	| codeBlock |
	codeBlock := self testedClass new.
	codeBlock label: 'sec123'.
	self assert: codeBlock hasLabel. 
	self assert: codeBlock label equals: 'sec123'

]

{ #category : #tests }
MicCodeBlockTest >> testSingleBlockWithArguments [
	"
	```language=pharo&caption=Getting a morph for an instance of ==Color==&label=scr:asMorphInColor
Color >> asMorph
    ^ Morph new color: self
	```
	"
	| source root code  textBody argument |
	textBody := 'Color >> asMorph
    ^ Morph new color: self'.
	argument := 'language=pharo&caption=Getting a morph for an instance of ==Color==&label=scr:asMorphInColor'.
	source := CodeblockMarkup, argument, String cr, textBody, String cr, CodeblockMarkup. 
	root := self parser parse: source.
	self assert: root children size equals: 1.
	code := root children first.
	self assert: code code equals: textBody.
	self assert: (code arguments at:#language) equals: 'pharo'.
	self assert: code captionElements first substring equals: 'Getting a morph for an instance of ==Color=='.
	self assert: (code arguments at:#label) equals: 'scr:asMorphInColor'.
]

{ #category : #tests }
MicCodeBlockTest >> testSingleBlockWithArgumentsWithFormat [

	"
	```language=pharo&caption=Getting a morph for an instance of ==Color==&label=scr:asMorphInColor
Color >> asMorph
    ^ Morph new color: self
	```
	"
	| source root code  textBody argument |
	textBody := 'Color >> asMorph
    ^ Morph new color: self'.
	argument := 'language=pharo&caption=`Color` is a class.&label=scr:asMorphInColor'.
	source := CodeblockMarkup, argument, String cr, textBody, String cr, CodeblockMarkup. 
	root := self parser parse: source.

	
	code := root children first.
	self assert: code code equals: textBody.
	self assert: code language equals: #pharo.
	self assert: (code arguments at: #language) equals: 'pharo'.
	
	self assert: code caption equals: 'Color is a class.'.
	self assert: code captionElements first kind equals: 'monospace'.
	self assert: code captionElements first substring equals: 'Color'.
	
	self assert: code captionElements second kind equals: 'basic'.
	self assert: code captionElements second substring equals: ' is a class.'.
	
	self assert: code label equals: 'scr:asMorphInColor'.
]

{ #category : #'as yet unclassified' }
MicCodeBlockTest >> testSingleBlockWithArgumentsWithFormat_amp_D8_L10 [

	"
	```language=pharo&caption=Getting a morph for an instance of ==Color==&label=scr:asMorphInColor
Color >> asMorph
    ^ Morph new color: self
	```
	"

	<smallAmpCoveres:
	'RemoveCaretOperator#MicCodeBlock class#defaultLanguage#18#26'>
	<smallAmpFrom:
	'MicCodeBlockTest>>#testSingleBlockWithArgumentsWithFormat'>
	<madeBySmallAmp>
	| source root code textBody argument aMicroDownParser |
	textBody := 'Color >> asMorph
    ^ Morph new color: self'.
	argument := '&4ZmN±sA<U1#*D`S0Q;~%J9J(f2gLnE@bP*):AU§^K$B.qsfh&gk}my@.p;&JvPu":2'.
	source := CodeblockMarkup , argument , String cr , textBody
	          , String cr , CodeblockMarkup.
	aMicroDownParser := self parser.
	root := aMicroDownParser parse: source.
	aMicroDownParser parse: source.


	code := root children first.
	self
		assert: code class equals: MicCodeBlock;
		deny: code hasCaption;
		assert: code code equals: 'Color >> asMorph
    ^ Morph new color: self';
		assert: code hasBody;
		assert: code hasNonDefaultArguments;
		deny: code hasNonDefaultLanguage;
		assert: code arguments class equals: MicArgumentsSplitter;
		assert: code arguments defaultValue equals: 'Pharo';
		assert: code arguments isHealthy;
		assert: code arguments isDictionary;
		assert: code arguments hasNonDefaultArguments;
		assert: code arguments capacity equals: 17;
		assert: code arguments size equals: 5;
		assert: code arguments keysSortedSafely class equals: Array;
		assert: code arguments keysSortedSafely size equals: 5;
		assert: code arguments keysSortedSafely
		equals: #( #'' #'4ZmN±sA<U1#*D`S0Q;~%J9J(f2gLnE@bP*):AU§^K$B.qsfh'
			   #'JvPu":2' #'gk}my@.p;' #language );
		assert: code arguments keys class equals: Array;
		assert: code arguments keys size equals: 5;
		assert: code arguments keys
		equals:
			#( #language #'' #'4ZmN±sA<U1#*D`S0Q;~%J9J(f2gLnE@bP*):AU§^K$B.qsfh'
			   #'gk}my@.p;' #'JvPu":2' );
		assert: code arguments values class equals: Array;
		assert: code arguments values size equals: 5;
		assert: code arguments values equals: #( 'Pharo' nil nil nil nil );
		assert: code arguments dictionaryClass asString
		equals: 'Dictionary';
		deny: code arguments hasNonDefaultValue;
		assert: code arguments associations class equals: Array;
		assert: code arguments associations size equals: 5;
		assert: (code arguments associations at: 1) class
		equals: Association;
		assert: (code arguments associations at: 2) class
		equals: Association;
		assert: (code arguments associations at: 3) class
		equals: Association;
		assert: (code arguments associations at: 4) class
		equals: Association;
		assert: (code arguments associations at: 5) class
		equals: Association;
		assert: code language equals: 'Pharo';
		deny: code hasLabel
]

{ #category : #'tests - deviation' }
MicCodeBlockTest >> testThreeBackQuotesClosedByFourQuotes [

	| codeBlock |
	codeBlock := parser parse: '``` 
something in the way
````'.

	self assert: codeBlock children first body equals: 'something in the way'
]

{ #category : #tests }
MicCodeBlockTest >> testedClass [ 
	^ MicCodeBlock 
]
