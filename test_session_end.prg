//	------------------------------------------------------------------------------
//	Title......: Session
//	Description: Test de creacion de Session y finalizacion de Session
//	Date.......: 16/06/2019
//	Last Upd...: 21/05/2020
//	------------------------------------------------------------------------------
//	{% LoadHRB( 'session.hrb' ) %}	//	Loading sessions module
//	------------------------------------------------------------------------------


function Main()

	//	Inicializo el sistema de Sessiones

		InitSession()

	//	Recupero los valores...
		
		? 'Variables de Session - F5 Refresh Page', '<br>Si refrescamos pantalla las variables ya no seran accesibles por haber cerrado la session<hr>'
		
		? 'DNI: '	, Session( 'dni' )				
		? 'Time: ' 	, Session( 'time' )	
		

	//	Cerramos Session. A partir de ahora las variables ya NO son accesibles...	
	
		EndSession()				

return nil 