
 #Include "MatLib.bi"

	Dim As Mat ptr A=MAT_Rand(4,4,-5,5)	
	Print "A=";
	 MAT_Show(A)		
	
	Dim As MatList ptr ml=MAT_LU(A)
	Dim As Mat ptr L=ml->LMat
	Dim As Mat ptr U=ml->LMatNext->LMat
	Dim As MatList Ptr ml1=MAT_QR(A)
	Dim As Mat ptr Q=ml1->LMat
	Dim As Mat ptr R=ml1->LMatNext->LMat
	
	Print "LU decomposition: "
	
	Print "L=";
	 MAT_Show(L)
	
	Print "U=";
	 MAT_Show(U)
	
	Print "QR decomposition: "
	
	Print "Q=";
	 MAT_Show(Q)	
	
	Print "R=";
	 MAT_Show(R)

 Sleep