package univr.bdd.piscine.beans;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Calendar;

/**
 * Questa classe mette a disposizione i metodi per effettuare interrogazioni
 * sulla base di dati.
 */
public class DataSource implements Serializable {

  // === Properties ============================================================

    private final String user = "userlab22";
    private final String passwd = "ventidueCD";
    private final String url = "jdbc:postgresql://dbserver.scienze.univr.it/dblab22";
    private final String driver = "org.postgresql.Driver";

  // === Methods ===============================================================

    public DataSource() throws ClassNotFoundException {
        Class.forName( driver );
    }

// === SELECT SPECIFICO UTENTE =========================================================
    public Persona login(int matr, String pwd) {
    	// dichiarazione delle variabili
    	Connection con = null;
    	Statement stmt = null;
    	ResultSet rs = null;
	Persona p = new Persona();
    	try {
            Class.forName(driver).newInstance();
            con = DriverManager.getConnection( url, user, passwd );
            stmt = con.createStatement();
            rs = stmt.executeQuery("select p.matricola, p.nome, p.cognome, p.datanascita, p.nomeimpianto, i.datachiusura from persona p join impianto i on "+
                    		"p.nomeimpianto = i.nome where p.matricola = '"+ matr +"' "+
                                "AND p.pw = '"+ pwd +"' AND p.lavoraa IS NULL ");
 
            if (rs.next()){				// found
                p.setMatricola( rs.getInt(1) );
		p.setNome( rs.getString(2) );
		p.setCognome( rs.getString(3) );
		p.setDataNascita( rs.getDate(4) );
		p.setNomeImpianto( rs.getString(5) );
		p.setDataChiusuraImpianto( rs.getString(6) );
		return p;
            } else 
                return p;

	} catch(Exception e ) {
	} finally {
            try {
        	con.close();
            } catch( SQLException sqle1 ) {
        	sqle1.printStackTrace();
            }
    	}
    	return p;
    }


  // === SELECT ALL IMPIANTI =========================================================
    public List<Impianto> getImpianti() {
    	// dichiarazione delle variabili
    	Connection con = null;
    	Statement stmt = null;
    	ResultSet rs = null;
	Boolean b = false;
	Calendar data = Calendar.getInstance();
    	List<Impianto> result = new ArrayList<Impianto>();

    	try {
            Class.forName(driver).newInstance();
            con = DriverManager.getConnection( url, user, passwd );
            stmt = con.createStatement();
            rs = stmt.executeQuery("SELECT nome, dataapertura, datachiusura, comune, indirizzo FROM impianto ");
            while( rs.next() ) {
        	result.add( makeImpiantoBean( rs ) );
            }
	} catch(Exception e ) {
	} finally {
            try {
        	con.close();
            } catch( SQLException sqle1 ) {
            	sqle1.printStackTrace();
            }
    	}
    	return result;
	}

	// SELECT nome, dataapertura, datachiusura, comune, indirizzo FROM impianto
    private Impianto makeImpiantoBean( ResultSet rs ) throws SQLException {
	Impianto bean = new Impianto();
	bean.setNome( rs.getString(1) );
	bean.setDataA( rs.getDate(2) );
	bean.setDataC( rs.getDate(3) );
	bean.setComune( rs.getString(4) );
	bean.setIndirizzo( rs.getString(5) );
	try {
            bean.getListaPiscine();			// Popola lista piscine del bean Impianto
            bean.getListaGiorni();			// Popola lista giorni del bean Impianto
	} catch(Exception e ) {}
        return bean;
    }

 // === SELECT PISCINE DI UN IMPIANTO =========================================================
    public List<Piscina> getPiscineImpianto(Impianto i) {
    	// dichiarazione delle variabili
    	Connection con = null;
    	Statement stmt = null;
    	ResultSet rs = null;
	Boolean b = false;
    	List<Piscina> result = new ArrayList<Piscina>();

    	try {
            Class.forName(driver).newInstance();
            con = DriverManager.getConnection( url, user, passwd );
            stmt = con.createStatement();
            rs = stmt.executeQuery("SELECT p.codice, p.dataapertura, p.datachiusura, p.oraapertura, p.orachiusura, p.tipo FROM piscina p JOIN impianto i ON "+
				"p.nomeimpianto = i.nome WHERE i.nome = '"+i.getNome()+"' ");
            while( rs.next() ) {
        	result.add( makePiscinaBean( rs ) );
            }
	} catch(Exception e ) {
	} finally {
            try {
        	con.close();
            } catch( SQLException sqle1 ) {
        	sqle1.printStackTrace();
            }
    	}
    	return result;
    }

	// SELECT nome, dataapertura, datachiusura, comune, indirizzo FROM impianto
    private Piscina makePiscinaBean( ResultSet rs ) throws SQLException {
	Piscina bean = new Piscina();
	bean.setCod( rs.getInt(1) );
	bean.setDataA( rs.getDate(2) );
	bean.setDataC( rs.getDate(3) );
	bean.setOraA( rs.getTime(4) );
	bean.setOraC( rs.getTime(5) );
	bean.setTipo( rs.getString(6).charAt(0) );
	return bean;
    }

// === SELECT GIORNI DI UN IMPIANTO =========================================================
    public List<Giorno> getGiorniImpianto(Impianto i, String dataI, String dataF) {
    	// dichiarazione delle variabili
    	Connection con = null;
    	Statement stmt = null;
    	ResultSet rs = null;
	Boolean b = false;
    	List<Giorno> result = new ArrayList<Giorno>();
	Calendar data = Calendar.getInstance();
	if(dataI.equals("") && dataF.equals("")){
            dataI = data.get(Calendar.YEAR)+"-0"+(data.get(Calendar.MONTH)+1)+"-01";
            dataF = data.get(Calendar.YEAR)+"-0"+(data.get(Calendar.MONTH)+1)+"-"+data.get(Calendar.DAY_OF_MONTH);
	}
    	try {
            Class.forName(driver).newInstance();
            con = DriverManager.getConnection( url, user, passwd );
            stmt = con.createStatement();
            rs = stmt.executeQuery("SELECT g.data, g.oraapertura, g.orachiusura, g.numeroingressi FROM giorno g JOIN impianto i ON "+
				"g.nomeimpianto = i.nome WHERE "+
				"i.nome = '"+i.getNome()+"' AND "+
				"g.data >= '"+dataI+"' AND "+
        			"g.data <= '"+dataF+"' ORDER BY g.data ");
            while( rs.next() ) {
                result.add( makeGiornoBean( rs ) );
            }
        } catch(Exception e ) {
	} finally {
            try {
        	con.close();
            } catch( SQLException sqle1 ) {
        	sqle1.printStackTrace();
            }
    	}
    	return result;
    }

	// SELECT nome, dataapertura, datachiusura, comune, indirizzo FROM impianto
    private Giorno makeGiornoBean( ResultSet rs ) throws SQLException {
	Giorno bean = new Giorno();
	bean.setData( rs.getDate(1) );
	bean.setOraA( rs.getTime(2) );
	bean.setOraC( rs.getTime(3) );
	bean.setNingr( rs.getInt(4) );
	return bean;
    }

// === SELECT CLIENTI INSERITI CON RELATIVI ACCESSI =========================================================
	public List<Clienti> getClienti() {
    	// dichiarazione delle variabili
    	Connection con = null;
    	Statement stmt = null;
    	ResultSet rs = null;
		Boolean b = false;
    	List<Clienti> result = new ArrayList<Clienti>();
		//Calendar data = Calendar.getInstance();

    	try {
			Class.forName(driver).newInstance();
      		con = DriverManager.getConnection( url, user, passwd );
      		stmt = con.createStatement();
      		rs = stmt.executeQuery("select c.codice, c.nome, c.cognome, c.tipodocumento, c.numerodocumento, i.nomeimpianto, "+
									"i.dataentrata, i.oraentrata, i.orauscita from cliente c left join biglietto b on c.codice=b.codicecliente "+
									"left join ingresso i on b.codice=i.codicebiglietto order by c.codice");
      		while( rs.next() ) {
        		result.add( makeClienteBean( rs ) );
      		}
		} catch(Exception e ) {
		} finally {
      		try {
        		con.close();
      		} catch( SQLException sqle1 ) {
        		sqle1.printStackTrace();
      		}
    	}
    	return result;
	}

// === SELECT CLIENTI INSERITI CON RELATIVI ACCESSI =========================================================
	public List<Clienti> getClientiEsterni(String impianto) {
    	// dichiarazione delle variabili
    	Connection con = null;
    	Statement stmt = null;
    	ResultSet rs = null;
		Boolean b = false;
    	List<Clienti> result = new ArrayList<Clienti>();
		//Calendar data = Calendar.getInstance();

    	try {
			Class.forName(driver).newInstance();
      		con = DriverManager.getConnection( url, user, passwd );
      		stmt = con.createStatement();
      		rs = stmt.executeQuery("select c.codice, c.nome, c.cognome, c.tipodocumento, c.numerodocumento from cliente c join iscritto i "+
									"on c.codice = i.codicecliente where c.codice not in (select codicecliente from iscritto "+
									"where nomeimpianto = '"+ impianto +"' ) group By c.codice ");
      		while( rs.next() ) {
        		result.add( makeClienteBean( rs ) );
      		}
		} catch(Exception e ) {
		} finally {
      		try {
        		con.close();
      		} catch( SQLException sqle1 ) {
        		sqle1.printStackTrace();
      		}
    	}
    	return result;
	}

// === SELECT ACCESSI DEI CLIENTI =========================================================
	public List<Clienti> getAccessi(int clienteSel, String dataI, String dataF, String impianto) {
    	// dichiarazione delle variabili
    	Connection con = null;
    	Statement stmt = null;
    	ResultSet rs = null;
		Boolean b = false;
    	List<Clienti> result = new ArrayList<Clienti>();
		//Calendar data = Calendar.getInstance();

    	try {
			Class.forName(driver).newInstance();
      		con = DriverManager.getConnection( url, user, passwd );
      		stmt = con.createStatement();
			if(clienteSel == 0)
      			rs = stmt.executeQuery("select c.codice, c.nome, c.cognome, c.tipodocumento, c.numerodocumento, i.nomeimpianto, "+
									"i.dataentrata, i.oraentrata, i.orauscita from cliente c join biglietto b on c.codice=b.codicecliente "+
									"join ingresso i on b.codice=i.codicebiglietto where i.dataentrata >= '"+ dataI +"' AND i.dataentrata <= '"+ dataF +
									"' AND i.nomeimpianto = '"+ impianto +"' order by (i.dataentrata, i.oraentrata) ");
			else 
				rs = stmt.executeQuery("select c.codice, c.nome, c.cognome, c.tipodocumento, c.numerodocumento, i.nomeimpianto, "+
									"i.dataentrata, i.oraentrata, i.orauscita from cliente c join biglietto b on c.codice=b.codicecliente "+
									"join ingresso i on b.codice=i.codicebiglietto where i.dataentrata >= '"+ dataI +"' AND i.dataentrata <= '"+ dataF +
									"' AND c.codice = "+ clienteSel +" AND i.nomeimpianto = '"+ impianto +"' order by (i.dataentrata, i.oraentrata) ");
      		while( rs.next() ) {
        		result.add( makeClienteBean( rs ) );
      		}
		} catch(Exception e ) {
		} finally {
      		try {
        		con.close();
      		} catch( SQLException sqle1 ) {
        		sqle1.printStackTrace();
      		}
    	}
    	return result;
	}

// === SELECT CLIENTI di un IMPIANTO =========================================================
	public List<Clienti> getClientiImpianto(String impianto) {
    	// dichiarazione delle variabili
    	Connection con = null;
    	Statement stmt = null;
    	ResultSet rs = null;
		Boolean b = false;
    	List<Clienti> result = new ArrayList<Clienti>();
		//Calendar data = Calendar.getInstance();

    	try {
			Class.forName(driver).newInstance();
      		con = DriverManager.getConnection( url, user, passwd );
      		stmt = con.createStatement();
      		rs = stmt.executeQuery("select c.codice, c.nome, c.cognome, c.tipodocumento, c.numerodocumento from cliente c join iscritto i on "+
									"c.codice = i.codicecliente where i.nomeimpianto = '"+ impianto +"' ");
      		while( rs.next() ) {
        		result.add( makeClienteBean( rs ) );
      		}
		} catch(Exception e ) {
		} finally {
      		try {
        		con.close();
      		} catch( SQLException sqle1 ) {
        		sqle1.printStackTrace();
      		}
    	}
    	return result;
	}


	// SELECT nome, dataapertura, datachiusura, comune, indirizzo FROM impianto
	private Clienti makeClienteBean( ResultSet rs ) throws SQLException {
		Clienti bean = new Clienti();
		bean.setCodCliente( rs.getInt(1) );
		bean.setNomeCliente( rs.getString(2) );
		bean.setCognomeCliente( rs.getString(3) );
		bean.setTipoDocumento( rs.getString(4).charAt(0) );
		bean.setNumeroDocumento( rs.getString(5) );
		try{
			bean.setTipoBiglietto( rs.getString(6).charAt(0) );
			bean.setNomeImpianto( rs.getString(6) );
			bean.setDataEntrata( rs.getDate(7) );
			bean.setOraEntrata( rs.getTime(8) );
			bean.setOraUscita( rs.getTime(9) );
		}catch(Exception e){}
		return bean;
	}

// === SELECT CLIENTI =========================================================
	public List<Clienti> getClientiAccessi(String impianto) {
    	// dichiarazione delle variabili
    	Connection con = null;
    	Statement stmt = null;
    	ResultSet rs = null;
		Boolean b = false;
    	List<Clienti> result = new ArrayList<Clienti>();
		//Calendar data = Calendar.getInstance();

    	try {
			Class.forName(driver).newInstance();
      		con = DriverManager.getConnection( url, user, passwd );
      		stmt = con.createStatement();
      		rs = stmt.executeQuery("select DISTINCT c.codice, c.nome, c.cognome from cliente c join biglietto b on c.codice = b.codicecliente "+
									"join ingresso i on b.codice = i.codicebiglietto where i.nomeimpianto = '"+ impianto +"' ");
      		while( rs.next() ) {
        		result.add( makeAccessoBean( rs ) );
      		}
		} catch(Exception e ) {
		} finally {
      		try {
        		con.close();
      		} catch( SQLException sqle1 ) {
        		sqle1.printStackTrace();
      		}
    	}
    	return result;
	}
	// SELECT nome, dataapertura, datachiusura, comune, indirizzo FROM impianto
	private Clienti makeAccessoBean( ResultSet rs ) throws SQLException {
		Clienti bean = new Clienti();
		bean.setCodCliente( rs.getInt(1) );
		bean.setNomeCliente( rs.getString(2) );
		bean.setCognomeCliente( rs.getString(3) );
		return bean;
	}

// === SELECT ABBONAMENTI CLIENTE =========================================================
	public List<Clienti> getAbbonamentiCliente(int codCliente, String dataOggi, String impianto) {
    	// dichiarazione delle variabili
    	Connection con = null;
    	Statement stmt = null;
    	ResultSet rs = null;
    	List<Clienti> result = new ArrayList<Clienti>();
        Calendar data = Calendar.getInstance();
    	try {
            Class.forName(driver).newInstance();
            con = DriverManager.getConnection( url, user, passwd );
            stmt = con.createStatement();
            rs = stmt.executeQuery("select DISTINCT(c.codice), b.codice, b.tipo, b.datainizio, b.datafine, b.ingressitotali, b.ingressirimasti from cliente c "+
                                    "join biglietto b on c.codice=b.codicecliente "+
                                    "join ingresso i on i.codicebiglietto = b.codice where c.codice = '"+ codCliente +"' "+
                                    "AND ( (b.datafine >= '"+ dataOggi +"' AND b.datafine <= '31/12/"+data.get(Calendar.YEAR)+"' ) OR b.ingressirimasti <> '0' ) "+
                                    "AND i.nomeimpianto = '"+ impianto + "' ");
            while( rs.next() ) {
        		result.add( makeAbbonamentoBean( rs ) );
      		}
		} catch(Exception e ) {
		} finally {
      		try {
        		con.close();
      		} catch( SQLException sqle1 ) {
        		sqle1.printStackTrace();
      		}
    	}
    	return result;
	}
	// SELECT nome, dataapertura, datachiusura, comune, indirizzo FROM impianto
	private Clienti makeAbbonamentoBean( ResultSet rs ) throws SQLException {
		Clienti bean = new Clienti();
		bean.setCodCliente( rs.getInt(1) );
		bean.setCodBiglietto( rs.getInt(2) );
		bean.setTipoBiglietto( rs.getString(3).charAt(0) );
		bean.setDataInizioAbbonamento( rs.getDate(4) );
		bean.setDataFineAbbonamento( rs.getDate(5) );
		bean.setTotaleIngressi( rs.getInt(6) );
		bean.setIngressiRimasti( rs.getInt(7) );
		return bean;
	}


  // === INSERISCI NUOVO UTENTE ================================================
	public boolean insertNewCliente(Clienti c){
		try{
			// create a mysql database connection
			Class.forName(driver);
			Connection conn = DriverManager.getConnection( url, user, passwd );
			String query = " insert into Cliente (nome, cognome, tipodocumento, numerodocumento)" + " values (?, ?, ?, ?)";
		 	// create the mysql insert preparedstatement
		    PreparedStatement preparedStmt = conn.prepareStatement(query);
		    preparedStmt.setString (1, c.getNomeCliente());
		    preparedStmt.setString (2, c.getCognomeCliente());
		    preparedStmt.setString (3, ""+c.getTipoDocumento());
		    preparedStmt.setString (4, c.getNumeroDocumento());
	 		// execute the preparedstatement
		  	preparedStmt.execute();
		   	conn.close();
		}
		catch (Exception e){
			return false;
		}
		return true;
	}

	public int getCodiceCliente(Clienti c) {
    	// dichiarazione delle variabili
    	Connection con = null;
    	Statement stmt = null;
    	ResultSet rs = null;

    	try {
			Class.forName(driver).newInstance();
      		con = DriverManager.getConnection( url, user, passwd );
      		stmt = con.createStatement();
      		rs = stmt.executeQuery("select codice from cliente where "+
									"nome = '"+ c.getNomeCliente() +"' AND "+
									"cognome = '"+ c.getCognomeCliente() +"' AND "+
									"tipodocumento = '"+ c.getTipoDocumento() +"' AND "+
									"numerodocumento = '"+ c.getNumeroDocumento() +"' ");
      		if( rs.next() )
        		return rs.getInt(1);
    
		} catch(Exception e ) {
		} finally {
      		try {
        		con.close();
      		} catch( SQLException sqle1 ) {
        		sqle1.printStackTrace();
      		}
    	}
    	return 0;
	}

	public boolean iscriviCliente(int codCliente, String impianto){
		try{
			// create a mysql database connection
			Class.forName(driver);
			Connection conn = DriverManager.getConnection( url, user, passwd );
			String query = " insert into iscritto (codicecliente, nomeimpianto)" + " values (?, ?)";
		 	// create the mysql insert preparedstatement
		    PreparedStatement  preparedStmt = conn.prepareStatement(query);
		    preparedStmt.setInt (1, codCliente);
		    preparedStmt.setString (2, impianto);
	 		// execute the preparedstatement
		  	preparedStmt.execute();
		}
		catch (Exception e){
			return false;
		}
		return true;
	}


	public boolean inserisciIngresso(int codBiglietto, char tipoBiglietto, String impianto, String data, String ora){
		try{
			// create a mysql database connection
			Class.forName(driver);
			PreparedStatement  preparedStmt;
			String query = "";
			Connection conn = DriverManager.getConnection( url, user, passwd );

			if(tipoBiglietto == 'd'|| tipoBiglietto == 'c'){
				query = " update biglietto set ingressirimasti = ingressirimasti-1 where codice = "+ codBiglietto +";";
		    	//preparedStmt = conn.prepareStatement(query1);
			}

			query += " insert into ingresso values ('"+codBiglietto+"', '"+impianto+"', '"+data+"', '"+ora+"' )";
		 	// create the mysql insert preparedstatement
		    preparedStmt = conn.prepareStatement(query);
	 		// execute the preparedstatement
		  	preparedStmt.execute();
		}
		catch (Exception e){
			return false;
		}
		return true;
	}

	public int nuovoBiglietto(int codCliente, char tipo, int prezzo, String dataI, String dataF, int ingressiT, int ingressiR){
		// dichiarazione delle variabili
    	Connection con = null;
    	Statement stmt = null;
		PreparedStatement  preparedStmt;
    	ResultSet rs = null;
		String query = "";

    	try {
			Class.forName(driver).newInstance();
      		con = DriverManager.getConnection( url, user, passwd );
      		stmt = con.createStatement();
			
			if(tipo == 'a'){
				query = " insert into biglietto (importo, tipo, datainizio, datafine, codicecliente )"+
						" values ('"+prezzo+"', '"+tipo+"', '"+dataI+"', '"+dataF+"', '"+codCliente+"') ";
			}
			else if(tipo == 'd'|| tipo == 'c'){
				query = " insert into biglietto (importo, tipo, ingressitotali, ingressirimasti, codicecliente )"+
						" values ('"+prezzo+"', '"+tipo+"', '"+ingressiT+"', '"+ingressiR+"', '"+codCliente+"') ";
			}
			else if(tipo == 's'){
				query = " insert into biglietto (importo, tipo, codicecliente )"+
						" values ('"+prezzo+"', '"+tipo+"', '"+codCliente+"') ";
			}else
				return -1;
			preparedStmt = con.prepareStatement(query);
		  	preparedStmt.execute();

			query = "select MAX(codice) from biglietto where codicecliente = '"+codCliente+"' ";
      		rs = stmt.executeQuery(query);

      		if( rs.next() )
        		return rs.getInt(1);
    
		} catch(Exception e ) {
		} finally {
      		try {
        		con.close();
      		} catch( SQLException sqle1 ) {
        		sqle1.printStackTrace();
      		}
    	}
    	return 0;
	}

	public boolean ingressiOggi(String data, String impianto){
		try{
			// create a mysql database connection
			Class.forName(driver);
			PreparedStatement  preparedStmt;
			String query = "";
			Connection conn = DriverManager.getConnection( url, user, passwd );

			query = " update giorno set numeroingressi = "+
					"(select count(*) from ingresso where nomeimpianto = '"+ impianto +"' and dataentrata = '"+ data +"') "+
					"where data = '"+ data +"' and nomeimpianto = '"+ impianto +"' ";
		 	// create the mysql insert preparedstatement
		    preparedStmt = conn.prepareStatement(query);
	 		// execute the preparedstatement
		  	preparedStmt.execute();
		}
		catch (Exception e){
			return false;
		}
		return true;
	}


	// === SELECT ABBONAMENTI CLIENTE =========================================================
	public List<Persona> getPersonale(String impianto) {
    	// dichiarazione delle variabili
    	Connection con = null;
    	Statement stmt = null;
    	ResultSet rs = null;
    	List<Persona> result = new ArrayList<Persona>();

    	try {
			Class.forName(driver).newInstance();
      		con = DriverManager.getConnection( url, user, passwd );
      		stmt = con.createStatement();
      		rs = stmt.executeQuery("select matricola, nome, cognome, datanascita, nomeimpianto from persona where "+
									"nomeimpianto = '"+ impianto +"' ");
      		while( rs.next() ) {
        		result.add( makePersonaBean( rs ) );
      		}
		} catch(Exception e ) {
		} finally {
      		try {
        		con.close();
      		} catch( SQLException sqle1 ) {
        		sqle1.printStackTrace();
      		}
    	}
    	return result;
	}
	// SELECT nome0, dataapertura, datachiusura, comune, indirizzo FROM impianto
	private Persona makePersonaBean( ResultSet rs ) throws SQLException {
		Persona bean = new Persona();
		bean.setMatricola( rs.getInt(1) );
		bean.setNome( rs.getString(2) );
		bean.setCognome( rs.getString(3) );
		bean.setDataNascita( rs.getDate(4) );
		bean.setNomeImpianto( rs.getString(5) );
		return bean;
	}
	
	public boolean registraTurno(int matricola, String impianto, String data){
		try{
			// create a mysql database connection
			Class.forName(driver);
			PreparedStatement  preparedStmt;
			Connection conn = DriverManager.getConnection( url, user, passwd );

			String query = " insert into turno (matricolapersona, nomeimpianto, data) values ('"+matricola+"', '"+impianto+"', '"+ data +"') ";
		 	// create the mysql insert preparedstatement
                        preparedStmt = conn.prepareStatement(query);
	 		// execute the preparedstatement
		  	preparedStmt.execute();
		}
		catch (Exception e){
			return false;
		}
		return true;
	}

}
