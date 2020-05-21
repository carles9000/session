//	------------------------------------------------------------------------------
//	Title......: Session
//	Description: Test de creacion de Session y recuperacion de valores almacenados
//	Date.......: 16/06/2019
//	Last Upd...: 21/05/2020
//	------------------------------------------------------------------------------
//	{% LoadHRB( 'session.hrb' ) %}	//	Loading sessions module
//	------------------------------------------------------------------------------


function Main()

	//	Inicializo el sistema de Sessiones

		InitSession()

	//	Recupero los valores...
		
		? 'Variables de Session - F5 Refresh Page<hr>'
		
		? 'DNI: '	, Session( 'dni' )				
		? 'Time: ' 	, Session( 'time' )	
		? 'Today: ' , Session( 'today' ) 		// First time doesn't exist
		
	//	Setter de valores
		
		Session( 'time', time() )				//	Actualizo variable 'time' a la Session
		Session( 'today', date() )			//	Añado variable 'today' a la Session
		
	
retu nil 