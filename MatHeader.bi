' Original creator -> "Roozbeh Abolpour", 2020
' From -> https://www.codeproject.com/Articles/5283245/Matrix-Library-in-C
' Porting to Freebasic (with new function names) -> "Joseba Epalza" (jepalza) 2021

' License By Code Project Open License (CPOL) 1.02

' Help Text:
' Some of these functions are provided to initial and define some specific matrices -> MAT_New, MAT_free
' There exist functions to initialize specific matrices -> MAT_Eye, Mat_Zeros, Mat_Ones, Mat_Rand
' The MAT_Set and MAT_Get functions are presented that will be used to get and set entry of the matrix located at a specific position
' Functions MAT_innermultiply(), MAT_scalermultiply(), MAT_multiply() compute the scaler and matrix multiplications
' Functions MAT_Plus and MAT_Minus compute the summation and minus of two pre-defined matrices
' To manipulate some parts of a matrix -> MAT_removerow and MAT_removecolumn are used for removing 
'     one specific row or column of the matrix, respectively
' Two types of inverse functions are developed which are MAT_inverse and MAT_triinverse. 
'     These functions calculate the inverse matrix of a square matrix in general and triangular forms, respectively
' A function MAT_rowechelon is presented that obtains the row echelon form of a given matrix
'     The row echelon form is a useful function for computing some important properties of a matrix 
'     such as its "MAT_Null" space. The row echelon form is basically obtained by a group of elementary Gaussian operations
' Functions MAT_Vconcat and MAT_Hconcat are presented that concatenate two matrices in vertical or horizontal structures
' Two important matrix decompositions are implemented, that are MAT_LU and MAT_QR decompositions. 


' creation, setting, getting, destruction
Declare Function MAT_New(r As Integer , c As Integer , d As Double) As Mat Ptr
Declare Sub MAT_Free(A As Mat Ptr)
Declare Sub MAT_Show(A As Mat Ptr)
Declare Sub MAT_Set(M As Mat Ptr , r As Integer , c As Integer , d As Double)
Declare Function MAT_Get(M As Mat Ptr , r As Integer , c As Integer) As Double

'
Declare Function MAT_SubMat(A As Mat Ptr , r1 As Integer , r2 As Integer , c1 As Integer , c2 As Integer) As Mat Ptr
Declare Sub MAT_SubMa2t(A As Mat Ptr , B As Mat Ptr , r1 As Integer , r2 As Integer , c1 As Integer , c2 As Integer)

' general purpouse
Declare Function MAT_Ones(r As Integer , c As Integer) As Mat Ptr
Declare Function MAT_Zeros(r As Integer , c As Integer) As Mat Ptr
Declare Function MAT_Eye(n As Integer) As Mat Ptr
Declare Function MAT_Plus(A As Mat Ptr , B As Mat Ptr) As Mat Ptr
Declare Function MAT_Minus(A As Mat Ptr , B As Mat Ptr) As Mat Ptr
Declare Function MAT_Rand(r As Integer , c As Integer , l As Double , u As Double) As Mat Ptr
Declare Function MAT_Multiply(A As Mat Ptr , B As Mat Ptr) As Mat Ptr
Declare Function MAT_ScalerMultiply(M As Mat Ptr , c As Double) As Mat Ptr	
Declare Function MAT_InnerMultiply(a As Mat Ptr , b As Mat Ptr) As Double
Declare Function MAT_Transpose(A As Mat Ptr) As Mat Ptr
Declare Function MAT_Adjoint(A As Mat Ptr) As Mat Ptr
Declare Function MAT_Inverse(A As Mat Ptr) As Mat Ptr
Declare Function MAT_CopyValue(A As Mat Ptr) As Mat Ptr
Declare Function MAT_TriInverse(A As Mat Ptr) As Mat Ptr
Declare Function MAT_Hconcat(A As Mat Ptr , B As Mat Ptr) As Mat Ptr
Declare Function MAT_Vconcat(A As Mat Ptr , B As Mat Ptr) As Mat Ptr
Declare Function MAT_Norm(A As Mat Ptr) As Double
Declare Function MAT_Det(M As Mat Ptr) As Double
Declare Function MAT_Trace(A As Mat Ptr) As Double

' Special
Declare Function MAT_RowEchelon(A As Mat Ptr) As Mat Ptr	
Declare Function MAT_Null(A As Mat Ptr) As Mat Ptr

' decompositions
Declare Function MAT_LU(A As Mat Ptr) As Mat Ptr
Declare Function MAT_QR(A As Mat Ptr) As Mat Ptr

' ROW and COL remove
Declare Function MAT_RemoveRow(A As Mat Ptr , r As Integer) As Mat Ptr
Declare Function MAT_RemoveCol(A As Mat Ptr , c As Integer) As Mat Ptr
Declare Sub MAT_RemoveRow2(A As Mat Ptr , B As Mat Ptr , r As Integer)	
Declare Sub MAT_RemoveCol2(A As Mat Ptr , B As Mat Ptr , c As Integer)
