Class {
	#name : #MicNodeTransformerTest,
	#superclass : #TestCase,
	#instVars : [
		'transformer'
	],
	#category : #'Microdown-Transformer-Tests'
}

{ #category : #running }
MicNodeTransformerTest >> setUp [
	super setUp.
	transformer := MicNodeTransformerCodeDeleterMock new

]

{ #category : #tests }
MicNodeTransformerTest >> testDeleteNode [

	| root |
	root := Microdown parse: '```
this is a paragraph
```'.
	self assert: root children first class equals: MicCodeBlock.
	transformer visit: root.
	self assert: root children size equals: 0
]

{ #category : #'as yet unclassified' }
MicNodeTransformerTest >> testDeleteNode_amp [

	"SmallAmp has derived this test from `MicNodeTransformerTest>>#testDeleteNode` by regenerating its assertions.
	This test can cover these parts:
	*	In `MicNodeTransformer>> #configuration` from 17 to 31:
		Operation: RemoveCaretOperator
		Code snippet: `^ configuration`
		Dynamic state: nil
		Mutant id: RemoveCaretOperator#MicNodeTransformer#configuration#17#31
	*	In `MicNodeTransformer>> #visit:` from 42 to 51:
		Operation: RemoveCaretOperator
		Code snippet: `^ anObject`
		Dynamic state: nil
		Mutant id: RemoveCaretOperator#MicNodeTransformer#visit:#42#51
"

	<madeBySmallAmp>
	| root aMicRootBlock |
	root := Microdown parse: '```
this is a paragraph
```'.
	aMicRootBlock := transformer visit: root.
	self
		assert: transformer configuration isNil;
		assert: aMicRootBlock class equals: MicRootBlock
]

{ #category : #tests }
MicNodeTransformerTest >> testReplaceNodeByAnotherNode [

	| root |
	root := Microdown parse: 'this is a paragraph'.
	self assert: root children first class equals: MicParagraphBlock.
	transformer visit: root.
	self assert: root children first class equals: MicTextBlock.
	self assert: root children first substring equals: 'test'
]
