#include "crt\stdio.bi" ' para printf
#include "crt\stdlib.bi" ' para malloc
#include "crt\Math.bi" ' para sqrt, pow, rand, etc



type Mat
	As Double Ptr entries
	As Integer row
	As Integer col
End Type

type MatList
	As Mat ptr LMat
	As MatList Ptr LMatNext
End Type

#Include "MatHeader.bi"

Sub MAT_Show(A As Mat Ptr)
	Dim As Integer i,j
	if(A->row>0 And A->col>0) Then 
		Dim As Integer k=0 
		printf(!"(") 
		for i=1 To A->row      
			for j=1 To A->col     
				if(j<A->col) Then 
					printf(!"%f\t",A->entries[k]) 
					k+=1
				Else
					printf(!"%f",A->entries[k]) 
					k+=1
				End If
			Next
			if(i<A->row) Then 
				printf(!"\n") 
			else 
				printf(!")\n") 
			End If
		Next
		printf(!"\n") 
	else  
		printf(!"()") 
	End If
End Sub


Function MAT_New(r As Integer , c As Integer , d As Double) As Mat Ptr
	Dim As Mat ptr M=malloc(sizeof(Mat)) 			
	M->row=r:M->col=c 
	M->entries=malloc(sizeof(double)*r*c) 
	Dim As Integer k=0 
	for i as Integer =1 To M->row        
		for j as Integer =1 To M->col       
			M->entries[k]=d 
			k+=1
		Next
	Next
	return M 
End Function


Sub MAT_Free(A As Mat Ptr)
	free(A->entries) 
	free(A) 
End Sub


Function MAT_Eye(n As Integer) As Mat Ptr
	Dim as Mat Ptr I=MAT_New(n,n,0) 
	for l as Integer =1 To n        
		I->entries[(l-1)*n+l-1]=1 
	Next
	return I
End Function


Function MAT_Zeros(r As Integer , c As Integer) As Mat Ptr
	Dim as Mat Ptr Z=MAT_New(r,c,0) 	
	return Z 
End Function


Function MAT_Ones(r As Integer , c As Integer) As Mat Ptr
	Dim as Mat Ptr O=MAT_New(r,c,1) 	
	return O 
End Function


Function MAT_Rand(r As Integer , c As Integer , l As Double , u As Double) As Mat Ptr
	Dim as Mat Ptr Randm=MAT_New(r,c,1) 	
	Dim As Integer k=0 
	for i as Integer =1 To r        
		for j as Integer =1 To c        
			Dim As Double r=(rand())/(RAND_MAX) 
			Randm->entries[k]=l+(u-l)*r 
			k+=1
     Next
	Next
	return Randm 
End Function


Function MAT_Get(M As Mat Ptr , r As Integer , c As Integer) As Double
	Dim As Double d=M->entries[(r-1)*M->col+c-1] 
	return d 
End Function


Sub MAT_Set(M As Mat Ptr , r As Integer , c As Integer , d As Double)
	M->entries[(r-1)*M->col+c-1]=d 
End Sub


Function MAT_ScalerMultiply(M As Mat Ptr , c As Double) As Mat Ptr	
	Dim as Mat Ptr B=MAT_New(M->row,M->col,0) 
	Dim As Integer k=0 
	for i As Integer=0 To M->row-1        
		for j As Integer=0 To M->col-1        
			B->entries[k]=M->entries[k]*c 
			k+=1 
		Next
	Next
	return B 
End Function


Function MAT_Plus(A As Mat Ptr , B As Mat Ptr) As Mat Ptr
	Dim As Integer r=A->row 
	Dim As Integer c=A->col 
	Dim as Mat Ptr D=MAT_New(r,c,0) 
	Dim As Integer k=0 	
	for i As Integer=0 To r-1       
		for j As Integer=0 To c-1       
			D->entries[k]=A->entries[k]+B->entries[k]
			k+=1 
		Next
	Next
	return D
End Function


Function MAT_Minus(A As Mat Ptr , B As Mat Ptr) As Mat Ptr
	Dim As Integer r=A->row 
	Dim As Integer c=A->col 
	Dim as Mat Ptr D=MAT_New(r,c,0) 
	Dim As Integer k=0 	
	for i As Integer=0 To r-1       
		for j As Integer=0 To c-1        
			D->entries[k]=A->entries[k]-B->entries[k] 
			k+=1 
		Next
	Next
	return D
End Function


Function MAT_SubMat(A As Mat Ptr , r1 As Integer , r2 As Integer , c1 As Integer , c2 As Integer) As Mat Ptr
	Dim as Mat Ptr B=MAT_New(r2-r1+1,c2-c1+1,0) 
	Dim As Integer k=0 
	for i As Integer=r1 To r2        
		for j As Integer=c1 To c2        
			B->entries[k]=A->entries[(i-1)*A->col+j-1]
			k+=1
		Next
	Next
	return B 
End Function


Sub MAT_SubMa2t(A As Mat Ptr , B As Mat Ptr , r1 As Integer , r2 As Integer , c1 As Integer , c2 As Integer)	
	Dim As Integer k=0 
	for i As Integer=r1 To r2        
		for j As Integer=c1 To c2        
			B->entries[k]=A->entries[(i-1)*A->col+j-1]
			k+=1
		Next
	Next
End Sub


Function MAT_Multiply(A As Mat Ptr , B As Mat Ptr) As Mat Ptr
	Dim As Integer r1=A->row 
	Dim As Integer r2=B->row 
	Dim As Integer c1=A->col 
	Dim As Integer c2=B->col 
	
	if (r1=1 And c1=1) Then 
		Dim as Mat Ptr C=MAT_ScalerMultiply(B,A->entries[0]) 
		return C 
	ElseIf (r2=1 And c2=1) Then
		Dim as Mat Ptr C=MAT_ScalerMultiply(A,B->entries[0])
		return C 
	End If
	
	Dim as Mat Ptr C=MAT_New(r1,c2,0) 
	for i as Integer =1 To r1        
		for j as Integer =1 To c2        
			Dim As Double de=0 
			for k As Integer =1 To r2        
				de+=A->entries[(i-1)*A->col+k-1]*B->entries[(k-1)*B->col+j-1] 
			Next
			C->entries[(i-1)*C->col+j-1]=de
		Next
	Next
	return C 
End Function


Function MAT_RemoveRow(A As Mat Ptr , r As Integer) As Mat Ptr
	Dim as Mat Ptr B=MAT_New(A->row-1,A->col,0) 
	Dim As Integer k=0 
	for i as Integer =1 To A->row        
		for j as Integer =1 To A->col        
			If (i<>r) Then 
				B->entries[k]=A->entries[(i-1)*A->col+j-1] 
				k+=1 
			End If
		Next
	Next
	return B 
End Function


Function MAT_RemoveCol(A As Mat Ptr , c As Integer) As Mat Ptr
	Dim as Mat Ptr B=MAT_New(A->row,A->col-1,0) 
	Dim As Integer k=0 
	for i as Integer =1 To A->row        
		for j as Integer =1 To A->col        
			If (j<>c) Then 
				B->entries[k]=A->entries[(i-1)*A->col+j-1]
				k+=1 
			End If
		Next
	Next
	return B 
End Function


Sub MAT_RemoveRow2(A As Mat Ptr , B As Mat Ptr , r As Integer)	
	Dim As Integer k=0 
	for i as Integer =1 To A->row        
		for j as Integer =1 To A->col        
			If (i<>r) Then 
				B->entries[k]=A->entries[(i-1)*A->col+j-1]				
				k+=1
			End If
		Next
	Next
End Sub


Sub MAT_RemoveCol2(A As Mat Ptr , B As Mat Ptr , c As Integer)	
	Dim As Integer k=0 
	for i as Integer =1 To A->row        
		for j as Integer =1 To A->col        
			If (j<>c) Then 
				B->entries[k]=A->entries[(i-1)*A->col+j-1]
				k+=1 				
			End If
		Next
	Next
End Sub


Function MAT_Transpose(A As Mat Ptr) As Mat Ptr
	Dim as Mat Ptr B=MAT_New(A->col,A->row,0) 
	Dim As Integer k=0 
	for i as Integer =1 To A->col        
		for j as Integer =1 To A->row        
			B->entries[k]=A->entries[(j-1)*A->row+i-1] 
			k+=1 
		Next
	Next
	return B 
End Function


Function MAT_Det(M As Mat Ptr) As Double
	Dim As Integer r=M->row 
	Dim As Integer c=M->col 
	If (r=1 And c=1) Then 
		Dim As Double d=M->entries[0] 
		return d 
	End If
 
	Dim as Mat Ptr M1=MAT_RemoveRow(M,1) 
	Dim as Mat Ptr M2=MAT_New(M->row-1,M->col-1,0) 
	Dim As Double d=0, si=+1 
	for j as Integer =1 To M->col        
		Dim As Double c=M->entries[j-1]		
		MAT_RemoveCol2(M1,M2,j) 				
		d+=si*MAT_Det(M2)*c 
		si*=-1 
	Next

	MAT_Free(M1) 
	MAT_Free(M2) 
	return d 
End Function


Function MAT_Trace(A As Mat Ptr) As Double
	Dim As Double d=0 
	for i as Integer =1 To A->row        
		d+=A->entries[(i-1)*A->row+i-1]
	Next
	return d 
End Function

Function MAT_Adjoint(A As Mat Ptr) As Mat Ptr
	Dim as Mat Ptr B =MAT_New(A->row,A->col,0) 	
	Dim as Mat Ptr A1=MAT_New(A->row-1,A->col,0) 
	Dim as Mat Ptr A2=MAT_New(A->row-1,A->col-1,0) 
	for i as Integer =1 To A->row        
		MAT_RemoveRow2(A,A1,i) 
		for j as Integer =1 To A->col        			
			MAT_RemoveCol2(A1,A2,j) 
			Dim As Double si=pow(-1,(i+j))
			B->entries[(i-1)*B->col+j-1]=MAT_Det(A2)*si 			
		Next
	Next

	Dim as Mat Ptr C=MAT_Transpose(B) 
	MAT_Free(A1) 
	MAT_Free(A2) 
	MAT_Free(B) 
	return C 
End Function


Function MAT_Inverse(A As Mat Ptr) As Mat Ptr
	Dim as Mat Ptr B=MAT_adjoint(A) 
	Dim As Double de=MAT_Det(A) 
	Dim as Mat Ptr C=MAT_ScalerMultiply(B,1/de) 
	MAT_Free(B) 
	return C 
End Function


Function MAT_CopyValue(A As Mat Ptr) As Mat Ptr
	Dim as Mat Ptr B=MAT_New(A->row,A->col,0) 
	Dim As Integer k=0 
	for i as Integer =1 To A->row        
		for j as Integer =1 To A->col        
			B->entries[k]=A->entries[k] 
			k+=1  
		Next
	Next
	return B 
End Function


Function MAT_TriInverse(A As Mat Ptr) As Mat Ptr
	Dim as Mat Ptr B=MAT_New(A->row,A->col,0) 
	for i as Integer =1 To B->row        
		for j As Integer=i To B->col        
			if(i=j) Then 
				B->entries[(i-1)*B->col+j-1]=1/A->entries[(i-1)*A->col+j-1] 
			Else
				B->entries[(i-1)*B->col+j-1]=-A->entries[(i-1)*A->col+j-1]/A->entries[(j-1)*A->col+j-1] 
			End If
		Next
	Next
	return B 
End Function


Function MAT_RowEchelon(A As Mat Ptr) As Mat Ptr	
	if(A->row=1) Then 
		for j as Integer =1 To A->col        
			If (A->entries[j-1]<>0) then 
				Dim as Mat Ptr B=MAT_ScalerMultiply(A,1/A->entries[j-1]) 
				return B 
			End If
		Next
		Dim as Mat Ptr B=MAT_New(1,A->col,0) 
		return B 
	End If
 	
	Dim as Mat Ptr B=MAT_copyvalue(A) 
	Dim As Integer ind1=B->col+1 
	Dim As Integer ind2=1 
	for i as Integer =1 To B->row        		
		for j as Integer =1 To B->col        
			If (B->entries[(i-1)*B->col+j-1]<>0 And j<ind1) then
				ind1=j 
				ind2=i 				
				' NOTA: no se si debe salir del bucle!!!!"
				Exit For
			End If
		Next
	Next

	If (ind2>1) Then 
		for j as Integer =1 To B->col        
			Dim As Double temp=B->entries[j-1] 
			B->entries[j-1]=B->entries[(ind2-1)*B->col+j-1] 
			B->entries[(ind2-1)*B->col+j-1]=temp 
		Next
	End If
 	
	If (B->entries[0]<>0) Then
		Dim As Double coeff=B->entries[0] 
		for j as Integer =1 To B->col        
			B->entries[j-1]/=coeff 
		Next
		for i As Integer=2 To B->row        	
			coeff=B->entries[(i-1)*B->col] 
			for j as Integer =1 To B->col        
				B->entries[(i-1)*B->col+j-1]-=coeff*B->entries[j-1] 
			Next
		Next
	else     
		Dim As Double coeff=0 
		for j as Integer =1 To B->col        
			If (B->entries[j-1]<>0 And coeff=0) Then
				coeff=B->entries[j-1] 
				B->entries[j-1]=1 
			ElseIf (B->entries[j-1]<>0) Then
				B->entries[j-1]/=coeff
			End If
		Next
	End If
 	
	Dim as Mat Ptr B1=MAT_RemoveRow(B,1) 
	Dim as Mat Ptr B2=MAT_RemoveCol(B1,1) 	
	Dim as Mat Ptr Be=MAT_RowEchelon(B2) 
	for i as Integer =1 To Be->row        
		for j as Integer =1 To Be->col        
			B->entries[i*B->col+j]=Be->entries[(i-1)*Be->col+j-1]
		Next
	Next

	MAT_Free(B1) 
	MAT_Free(B2) 	
	MAT_Free(Be) 
	return B 
End Function


Function MAT_Hconcat(A As Mat Ptr , B As Mat Ptr) As Mat Ptr
	Dim as Mat Ptr C=MAT_New(A->row,A->col+B->col,0) 
	Dim As Integer k=0 
	for i as Integer =1 To A->row        
		for j as Integer =1 To A->col        
			C->entries[k]=A->entries[(i-1)*A->col+j-1] 
			k+=1  
		Next
		for j as Integer =1 To B->col        
			C->entries[k]=B->entries[(i-1)*B->col+j-1] 
			k+=1  
		Next
	Next
	return C 
End Function


Function MAT_Vconcat(A As Mat Ptr , B As Mat Ptr) As Mat Ptr
	Dim as Mat Ptr C=MAT_New(A->row+B->row,A->col,0) 
	Dim As Integer k=0 
	for i as Integer =1 To A->row        
		for j as Integer =1 To A->col        
			C->entries[k]=A->entries[(i-1)*A->col+j-1] 
			k+=1  
		Next
	Next
	for i as Integer =1 To B->row        
		for j as Integer =1 To B->col        
			C->entries[k]=B->entries[(i-1)*B->col+j-1] 
			k+=1  
		Next
	Next
	return C 
End Function


Function MAT_Norm(A As Mat Ptr) As Double
	Dim As Double d=0 
	Dim As Integer k=0 
	for i as Integer =1 To A->row        
		for j as Integer =1 To A->col        
			d+=A->entries[k]*A->entries[k] 
			k+=1  
		Next
	Next
	d=sqrt(d) 
	return d 
End Function


Function MAT_Null(A As Mat Ptr) As Mat Ptr
	Dim as Mat Ptr RM=MAT_RowEchelon(A) 
	Dim As Integer k=RM->row 
	for i As Integer=RM->row To 1 Step -1      
		Dim As Byte flag=false 
		for j as Integer =1 To RM->col        
			If (RM->entries[(i-1)*RM->col+j-1]<>0) then 
				flag=true 
				' NOTA: no se si debe salir del bucle!!!!"
				exit For
			End If
		Next
		if(flag) Then 
			k=i 
			' NOTA: no se si debe salir del bucle!!!!" 
			Exit For
		End If
	Next

	Dim as Mat Ptr RRM=MAT_SubMat(RM,1,k,1,RM->col) 
	MAT_Free(RM) 	
	Dim As Integer nn=RRM->col-RRM->row 
	If (nn=0) Then 
		Dim as Mat Ptr N=MAT_New(0,0,0) 
		return N 
	End If
 
	Dim as Mat Ptr R1=MAT_SubMat(RRM,1,RRM->row,1,RRM->row) 
	Dim as Mat Ptr R2=MAT_SubMat(RRM,1,RRM->row,1+RRM->row,RRM->col) 				
	MAT_Free(RRM) 
	Dim as Mat Ptr I=MAT_Eye(nn) 
	Dim as Mat Ptr T1=MAT_Multiply(R2,I) 	
	MAT_Free(R2) 
	Dim as Mat Ptr R3=MAT_ScalerMultiply(T1,-1) 
	MAT_Free(T1) 
	Dim as Mat Ptr T2=MAT_triinverse(R1) 
	MAT_Free(R1) 
	Dim as Mat Ptr X=MAT_Multiply(T2,R3) 	
	MAT_Free(T2) 
	MAT_Free(R3) 	
	Dim as Mat Ptr N=MAT_Vconcat(X,I) 
	MAT_Free(I) 
	MAT_Free(X) 
	for j as Integer =1 To N->col        
		Dim As Double de=0 
		for i as Integer =1 To N->row        
			de+=N->entries[(i-1)*N->col+j-1]*N->entries[(i-1)*N->col+j-1]
		Next
		de=sqrt(de) 
		for i as Integer =1 To N->row        
			N->entries[(i-1)*N->col+j-1] / =de 
		Next
	Next
	
	return N 
End Function


Function MAT_Lu(A As Mat Ptr) As Mat Ptr
	If (A->row=1) Then 
		Dim As MatList ptr ml=malloc(sizeof(MatList)) 
		ml->LMat=MAT_New(1,1,A->entries[0]) 	
		ml->LMatNext=malloc(sizeof(MatList)) 
		ml->LMatNext->LMat=MAT_New(1,1,1) 
		return ml
	End If
 
	Dim As Double aa=A->entries[0] 
	Dim As Double c=0 
	If (aa<>0) Then 
		c=1/aa 
	End If
 
	Dim as Mat Ptr w =MAT_SubMat(A,1,1,2,A->col) 
	Dim as Mat Ptr v =MAT_SubMat(A,2,A->row,1,1) 
	Dim as Mat Ptr Ab=MAT_SubMat(A,2,A->row,2,A->col) 	
	Dim as Mat Ptr T1=MAT_Multiply(v,w) 
	Dim as Mat Ptr T2=MAT_ScalerMultiply(T1,-c) 
	Dim as Mat Ptr T3=MAT_Plus(Ab,T2) 
	Dim As MatList ptr mlb=MAT_Lu(T3) 
	MAT_Free(T1) 
	MAT_Free(T2) 
	MAT_Free(T3) 
	MAT_Free(Ab) 
	Dim as Mat Ptr L=MAT_New(A->row,A->col,0) 
	Dim as Mat Ptr U=MAT_New(A->row,A->col,0) 
	Dim As Integer k=0 
	for i as Integer =1 To A->row        
		for j as Integer =1 To A->col        
			If (i=1 And j=1) Then  
				L->entries[k]=1 
				U->entries[k]=aa 
				k+=1  
			ElseIf (i=1 And j>1) Then 
				U->entries[k]=w->entries[j-2]
				k+=1  
			ElseIf (i>1 And j=1) Then 
				L->entries[k]=c*v->entries[i-2]
				k+=1  
			Else
				L->entries[k]=mlb->LMat->entries[(i-2)*mlb->LMat->col+j-2] 
				U->entries[k]=mlb->LMatNext->LMat->entries[(i-2)*mlb->LMatNext->LMat->col+j-2] 
				k+=1  
			End If
		Next
	Next

	Dim As MatList ptr ml=malloc(sizeof(MatList)) 
	ml->LMat=L 
	ml->LMatNext=malloc(sizeof(MatList))
	ml->LMatNext->LMat=U 
	MAT_Free(w) 
	MAT_Free(v) 	
	free(mlb) 
	return ml 
End Function


Function MAT_InnerMultiply(a As Mat Ptr , b As Mat Ptr) As Double
	Dim As Double d=0 
	Dim As Integer n=a->row 
	if(a->col>n) Then 
		n=a->col 
	End If
 
	for i as Integer =1 To n        
		d+=a->entries[i-1]*b->entries[i-1]
	Next

	return d 
End Function


Function MAT_Qr(A As Mat Ptr) As Mat Ptr
	Dim As Integer ro=A->row 
	Dim As Integer co=A->col 
	Dim as Mat Ptr Q=MAT_New(ro,ro,0) 
	Dim as Mat Ptr R=MAT_New(ro,co,0) 	
	Dim as Mat Ptr ek=MAT_New(ro,1,0) 
	Dim as Mat Ptr uj=MAT_New(ro,1,0) 
	Dim as Mat Ptr aj=MAT_New(ro,1,0) 
	for j as Integer =1 To ro        
		MAT_SubMa2t(A,aj,1,ro,j,j) 
		for k As Integer =1 To ro        
			uj->entries[k-1]=aj->entries[k-1] 
		Next
		
		for k As Integer =1 To j-1        	
			MAT_SubMa2t(Q,ek,1,ro,k,k) 
			Dim As Double proj=MAT_InnerMultiply(aj,ek) 			
			for l As Integer =1 To ek->row        
				ek->entries[l-1]*=proj 
			Next
			uj=MAT_Minus(uj,ek) 
		Next
		
		Dim As Double nuj=MAT_Norm(uj) 		
		for i as Integer =1 To ro       
			Q->entries[(i-1)*ro+j-1]=uj->entries[i-1]/nuj 
		Next

		for j1 As Integer=j To co        
			R->entries[(j-1)*co+j1-1]=MAT_InnerMultiply(uj,MAT_SubMat(A,1,ro,j1,j1))/nuj 			
		Next
	Next
	
	Dim As MatList Ptr ml=malloc(sizeof(MatList)) 
	ml->LMat=Q 
	ml->LMatNext=malloc(sizeof(MatList))
	ml->LMatNext->LMat=R 
	MAT_Free(ek) 
	MAT_Free(uj) 
	MAT_Free(aj) 
	return ml 
End Function

