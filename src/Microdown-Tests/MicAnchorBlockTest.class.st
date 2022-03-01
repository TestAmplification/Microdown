Class {
	#name : #MicAnchorBlockTest,
	#superclass : #MicBlockTest,
	#category : #'Microdown-Tests-Parser'
}

{ #category : #tests }
MicAnchorBlockTest >> testModifyLabel [
	| mic |
	mic := (parser parse: '@label') children first.
	self assert: mic label equals: 'label'.
	mic label: 'label2'.
	self assert: mic label equals: 'label2'.
]

{ #category : #'as yet unclassified' }
MicAnchorBlockTest >> testModifyLabel_amp_A1 [

	"SmallAmp has derived this test from `MicAnchorBlockTest>>#testModifyLabel` by applying some transformations and regenerating its assertions.
	This test can cover this part:
	*	In `MicAnchorBlock>> #asPillar` from 12 to 52:
		Operation: RemoveCaretOperator
		Code snippet: `^ PRAnchor new
	  name: self label;
	  yourself`
		Dynamic state: nil
		Mutant id: RemoveCaretOperator#MicAnchorBlock#asPillar#12#52
"

	<madeBySmallAmp>
	| mic aPRAnchor |
	mic := (parser parse: '@label') children first.
	self assert: mic hasLabel.
	aPRAnchor := mic
		             label: 'label2';
		             asPillar.
	self assert: aPRAnchor class equals: PRAnchor
]

{ #category : #tests }
MicAnchorBlockTest >> testedClass [ 
	^ MicAnchorBlock 
]
