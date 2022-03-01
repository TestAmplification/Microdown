Class {
	#name : #MicLinkBlockTest,
	#superclass : #MicElementTest,
	#instVars : [
		'splitterClass'
	],
	#category : #'Microdown-Tests-Parser'
}

{ #category : #functions }
MicLinkBlockTest >> linkBoldSample [

	^ '
[**Foo**](/anUrl)
'
]

{ #category : #functions }
MicLinkBlockTest >> linkItalicSample [

	^ '
[_Foo_](/anUrl)
'
]

{ #category : #functions }
MicLinkBlockTest >> linkMonospaceSample [

	^ '
[`Foo`](/anUrl)
'
]

{ #category : #functions }
MicLinkBlockTest >> linkNestedSample [

	^ '
[**_Foo_**](/anUrl)
'
]

{ #category : #functions }
MicLinkBlockTest >> linkSample [

	^ '
[Foo](/anUrl)
'
]

{ #category : #functions }
MicLinkBlockTest >> linkStrikeSample [

	^ '
[~Foo~](/anUrl)
'
]

{ #category : #running }
MicLinkBlockTest >> setUp [

	super setUp.
	parser := self parser. 
	splitterClass := MicInlineParser
]

{ #category : #'tests - link' }
MicLinkBlockTest >> testLinkAPIToAccessText [

	| link |
	link := (self parser parse: self linkSample) children first
		        children first.
	self assert: link class equals: MicLinkBlock.
	self assert: link url equals: '/anUrl'
]

{ #category : #'as yet unclassified' }
MicLinkBlockTest >> testLinkAPIToAccessText_amp [

	"SmallAmp has derived this test from `MicLinkBlockTest>>#testLinkAPIToAccessText` by regenerating its assertions.
	This test can cover these parts:
	*	In `MicLinkBlock>> #openingDelimiter` from 21 to 42:
		Operation: RemoveCaretOperator
		Code snippet: `^ LinkNameOpenerMarkup`
		Dynamic state: nil
		Mutant id: RemoveCaretOperator#MicLinkBlock#openingDelimiter#21#42
	*	In `MicLinkBlock>> #kind` from 9 to 19:
		Operation: RemoveCaretOperator
		Code snippet: `^ #linkName`
		Dynamic state: nil
		Mutant id: RemoveCaretOperator#MicLinkBlock#kind#9#19
	*	In `MicLinkBlock>> #reference` from 13 to 23:
		Operation: RemoveCaretOperator
		Code snippet: `^ reference`
		Dynamic state: nil
		Mutant id: RemoveCaretOperator#MicLinkBlock#reference#13#23
"

	<madeBySmallAmp>
	| link |
	link := (self parser parse: self linkSample) children first children
		        first.
	self
		assert: link reference class equals: MicFileResourceReference;
		assert: link openingDelimiter equals: '[';
		assert: link kind equals: #linkName
]

{ #category : #'tests - link' }
MicLinkBlockTest >> testLinkAPIToSetText [

	| link |
	link := (self parser parse: self linkSample) children first
		        children first.
	self assert: link class equals: MicLinkBlock.

	link captionElements: { (MicTextBlock new substring: 'Blblbl') }.
	self assert: link caption equals: 'Blblbl'
]

{ #category : #'tests - link' }
MicLinkBlockTest >> testLinkBoldAPIToAccessText [

	| link |
	link := (self parser parse: self linkBoldSample) children first
		        children first.
	self assert: link class equals: MicLinkBlock.
	self assert: link children first class equals: MicBoldFormatBlock.
	self assert: link children first children first class equals: MicTextBlock.

	self assert: link url equals: '/anUrl'
]

{ #category : #'tests - link' }
MicLinkBlockTest >> testLinkCreatesInnerText [

	| link |
	link := (self parser parse: '[ab](https://ab.com)') children first
		        children first.
	self assert: link class equals: MicLinkBlock.
	self assert: link url equals: 'https://ab.com'
]

{ #category : #'tests - link' }
MicLinkBlockTest >> testLinkItalicAPIToAccessText [

	| link |
	link := (self parser parse: self linkItalicSample) children first
		        children first.
	self assert: link class equals: MicLinkBlock.
	self assert: link children first class equals: MicItalicFormatBlock.
	self
		assert: link children first children first class
		equals: MicTextBlock.

	self assert: link url equals: '/anUrl'
]

{ #category : #tests }
MicLinkBlockTest >> testPrintOn [

	| link |
	link := (splitterClass new parse: '[caption](http://www.pharo.org)') first.
	self assert: link asString equals: '[caption](http://www.pharo.org)'
]

{ #category : #tests }
MicLinkBlockTest >> testUrl [

	| link |
	link := (splitterClass new parse: '[caption](http://www.pharo.org:8080)') first.
	self assert: link url equals: 'http://www.pharo.org:8080'
]

{ #category : #tests }
MicLinkBlockTest >> testedClass [ 
	^ MicHorizontalLineBlock
]
