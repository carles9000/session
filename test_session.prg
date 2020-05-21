//	------------------------------------------------------------------------------
//	Title......: Session
//	Description: Test de creacion de Session
//	Date.......: 16/06/2019
//	Last Upd...: 21/05/2020
//	------------------------------------------------------------------------------
//	{% LoadHRB( 'session.hrb' ) %}	//	Loading sessions module
//	------------------------------------------------------------------------------


function Main()

	local cDni 	:= '39690495X'
	local cTime 	:= time()


	//	Inicializo el sistema de Sessiones
		
		InitSession()		
		
		
	//	Salvo mis variables que recuperare desde otras páginas...
		
		Session( 'dni',  cDni )
		Session( 'time', cTime )
		

		? 'Se ha creado una session y añadido las variables dni y time'
		? 'En la siguiente pantalla los recuperare...'
		? '<hr>'
		
		? 'Dni: ' , cDni
		? 'Time: ' , cTime
		
	
retu nil 
