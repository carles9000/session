//	------------------------------------------------------------------------------
//	Title......: Session
//	Description: Módulo de sesiones
//	Date.......: 16/06/2019
//	Last Upd...: 21/05/2020
//	------------------------------------------------------------------------------
//	InitSession()	- Creacion de una Session. Una vez creada la session puedes 
//					  almacenar/recuperar variables 
//
//	Session() 		- Setter/Getter . Almacena/recupera los valores de las variables
//					  Session( <NameVar>, [<uValue>] )	 
//
//  EndSession()  - Eliminar una session del servidor
//
//	------------------------------------------------------------------------------
//	Ejemplos por orden de ejecucion:
//
//	test_session.prg			- Crear session y salvar variables
//	test_session_read.prg		- Crear session y recuperar variables almacenadas
//	test_session_end.prg		- Crear session y eliminar session
//	------------------------------------------------------------------------------

#include 'hbclass.ch'
#include 'hboo.ch'

#define SESSION_PREFIX  		'session_'
#define SESSION_NAME    		'HRBSESSID'
#define SESSION_EXPIRED 		3600

function InitSession()

	local o := TSession():New()
	
	o:InitSession()

retu nil

function Session( cKey, uValue )

	local o := TSession():New()
	
retu o:Session( cKey, uValue )

function EndSession()

	local o := TSession():New()
	
	o:EndSession()

retu nil

CLASS TSession 

	CLASSDATA lInit						INIT .F.
	CLASSDATA hSession 				INIT NIL
	CLASSDATA cSID 						INIT ''
	CLASSDATA lIs_Session				INIT .F.
			
	DATA 	cDirTmp					INIT HB_DirTemp()
			
	METHOD  New() 						CONSTRUCTOR
	
	METHOD  InitSession()
	METHOD  Session( cKey, uValue )	
	METHOD  EndSession()
	METHOD  SaveSession()
	METHOD  Get_Session()
	METHOD  StrSession()
	METHOD  SetSession()	

ENDCLASS 

METHOD New() CLASS TSession

	if !::lInit 

		::lInit := .T.

		::Get_Session()
		
	endif
	
retu Self

METHOD InitSession() CLASS TSession

	local cSession, cFile
	
	if ::lIs_Session
	
		//	Recuperar contenido del fichero de session...
		
			cFile 		:= ::cDirTmp + SESSION_PREFIX + ::cSID 		
		
		if File( cFile )

			cSession := Memoread( cFile )		
		
			//	Si hay contenido Deserializaremos...
			
				if ( !empty( cSession ) )

					::hSession := hb_Deserialize( cSession )

					if Valtype( ::hSession ) == 'H' 
					
						//	Validaremos si esta Session es del solicitante, fecha de caducidad...					
					
					endif
					
				else	//	Incializamos Session

					::StrSession()
					
				endif
				
		else 	//	Si NO existe el fichero, creamos la estructura de una Session

			::StrSession()							

		endif
		
	else
	
		//	Si no existe una Session la iniciamos...
		
			::SetSession() 
		
			::StrSession()
	
		//	Salvo la nueva session 
		
			cSession 	:= hb_Serialize( ::hSession )
			
			cFile 		:= ::cDirTmp + SESSION_PREFIX + ::cSID 

		//	Pondremos la 'data' de la session accesible por el usuario
		//	Tenemos definida un __hGet, podriamos definir de momento un __hSession	

		::lIs_Session := .T.
	
	endif
	
	//	Renovamos la cookie, cada vez que ejecutamois con el tiempo renovado...

		SetCookie( SESSION_NAME, ::cSID, SESSION_EXPIRED )		


retu nil

//	------------------------------------------------------------------------------

METHOD Session( cKey, uValue )  CLASS TSession

	if !::lIs_Session
		retu ''
	endif

	if ValType( uValue ) <> 'U' 		//	SETTER
	
		if !empty( cKey ) 
		
			::hSession[ 'data' ][ cKey ] := uValue		
		
		endif
	
	else								// GETTER

		if ( hb_HHasKey( ::hSession[ 'data' ], cKey  ) )
			retu ::hSession[ 'data' ][ cKey ] 
		else
			retu ''
		endif
		
	endif

retu nil

//	------------------------------------------------------------------------------

METHOD EndSession() CLASS TSession

	local cFile 	
	
	if !::lIs_Session
		retu nil 
	endif	

	if ( Valtype( ::hSession ) == 'H'  )
	
		//	Enviaremos la cookie con tiempo expirado. Esto la eliminara y no se volverá a enviar...
		
			setcookie( SESSION_NAME, ::cSID, -1 )
		
		//	Eliminamos Session de disco
	
			cFile := ::cDirTmp + SESSION_PREFIX + ::cSID 
			
			fErase( cFile )
			
	endif
	
	//	Eliminamos variable GLOBAL de Session
	
		::hSession  	:= NIL
		::cSID			:= ''
		::lIs_Session	:= .F.
	
retu nil

//	------------------------------------------------------------------------------

METHOD SaveSession() CLASS TSession

	local cSession, cFile, lSave

	if !::lIs_Session
		retu ''
	endif
	
	if ( Valtype( ::hSession ) == 'H' )
	
		//	Si estructura es correcta, procederemos a salvaremos
		
		if ( 	hb_HHasKey( ::hSession, 'ip'   ) .and. ;
				hb_HHasKey( ::hSession, 'sid'  ) .and. ;
				hb_HHasKey( ::hSession, 'data' ) )

			cSession 	:= hb_Serialize( ::hSession )		
			cFile 	 	:= ::cDirTmp + SESSION_PREFIX + ::cSID 							
			lSave 		:= memowrit( cFile, cSession )			
				
		endif

	endif		

retu NIL 

//	------------------------------------------------------------------------------

METHOD SetSession()  CLASS TSession
    
    ::cSID := hb_MD5( DToS( Date() ) + Time() + Str( hb_Random(), 15, 12 ) )    

retu nil

//	------------------------------------------------------------------------------

METHOD Get_Session() CLASS TSession

	local hGet 		:= AP_GetPairs()
	local hCookies

	::cSID := hb_HGetDef( hGet, SESSION_NAME, '' )
	
	if ! empty( ::cSID ) 	//	GET
	
		::lIs_Session := .T.
	
	else
	
		hCookies := getCookies()				//	getcookie() ya estará en el core
		
		::cSID := hb_HGetDef( hCookies, SESSION_NAME, '' )
		
		::lIs_Session := !empty( ::cSID )				
		
	endif
	
retu ::lIs_Session 

//	------------------------------------------------------------------------------

METHOD StrSession() CLASS TSession

	::hSession := { => }
	
	::hSession[ 'ip'     ] := AP_USERIP()			//	La Ip no es fiable. Pueden usar proxy
	::hSession[ 'sid'    ] := ::cSID
	::hSession[ 'expired'] := hb_milliseconds() + SESSION_EXPIRED
	::hSession[ 'data'   ] := { => }

retu nil

//	------------------------------------------------------------------------------
//	Creamos Instancia TSession() y Salvamos si es que te nemos session abierta

EXIT PROCEDURE __ExitSession()

	local o		:= TSession():New()
	
	o:SaveSession()
	
retu 