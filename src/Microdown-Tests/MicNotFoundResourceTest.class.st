Class {
	#name : #MicNotFoundResourceTest,
	#superclass : #MicReferenceTestCase,
	#category : #'Microdown-Tests-Resources'
}

{ #category : #testing }
MicNotFoundResourceTest >> errorText [

	^ 'Sample error text'
]

{ #category : #testing }
MicNotFoundResourceTest >> resourceReference [

	^ 'file:///xzyxzy.txt' 

]

{ #category : #running }
MicNotFoundResourceTest >> setUp [

	super setUp.
	resource := MicNotFoundResource 
		resource: self resourceReference
		error: (Error new messageText: self errorText)

]

{ #category : #testing }
MicNotFoundResourceTest >> testAsForm [

	self assert: resource asForm equals: nil

]

{ #category : #'as yet unclassified' }
MicNotFoundResourceTest >> testAsForm_amp [

	"SmallAmp has derived this test from `MicNotFoundResourceTest>>#testAsForm` by regenerating its assertions.
	This test can cover this part:
	*	In `MicNotFoundResource>> #notFoundReference` from 21 to 36:
		Operation: RemoveCaretOperator
		Code snippet: `^ self reference`
		Dynamic state: nil
		Mutant id: RemoveCaretOperator#MicNotFoundResource#notFoundReference#21#36
"

	<madeBySmallAmp>
	resource asForm.
	self assert: resource notFoundReference equals: 'file:///xzyxzy.txt'
]

{ #category : #testing }
MicNotFoundResourceTest >> testAsText [

	self assert: resource asText equals: 'Resource not found' asText
]

{ #category : #testing }
MicNotFoundResourceTest >> testError [

	self assert: (resource error isKindOf: Error).
	self assert: resource error messageText equals: self errorText

]

{ #category : #testing }
MicNotFoundResourceTest >> testExists [

	self deny: resource exists

]

{ #category : #testing }
MicNotFoundResourceTest >> testNotFoundReference [

	self assert: resource reference equals: self resourceReference

]

{ #category : #testing }
MicNotFoundResourceTest >> testParseMicrodown [

	self should: [ resource parseMicrodown ] raise: Error

]
