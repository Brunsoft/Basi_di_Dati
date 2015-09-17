package univr.bdd.piscine.beans;

import javax.annotation.PostConstruct;
import java.io.Serializable;
import javax.faces.application.FacesMessage;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Date;
import java.util.Calendar;
import java.util.Iterator;


@ManagedBean(name = "loginBean")
@SessionScoped
public class LoginBean implements Serializable {

  // === Properties ============================================================

    private static final long serialVersionUID = 1L;	// Variabili LOGIN
    private String message;
    private Persona utente;		

    private DataSource ds;				// Variabili HOME
    private List<Impianto> listaImpianti;

    private Impianto impiantoSel;			// Variabili IMPIANTO
    private Calendar data = Calendar.getInstance();
    private String dataOggi = "", dataI = "", dataF = "", ora = "";
    private String dataInizioAccessi = "", dataFineAccessi = "";

    private List<Clienti> listaClienti;			// tutti i clienti
    private List<Clienti> listaClientiEsterni;		// titti i clienti non iscritti all'impianto corrente
    private List<Clienti> clientiAccessi;               // tutti i clienti che hanno eseguito accessi
    private List<Clienti> clientiImpianto;		// tutti i clienti dell'impianto corrente
    private List<Clienti> listaAbbonamentiCliente;	
    private int clienteSel = 0;
    private int clienteSelListaAcc = 0;
    private int clienteSelNuovoAcc = 0;

    private List<Persona> listaPersonale;               // chiusura giornata
    private List<Persona> listaPersonaleOggi;	

// === Methods ===============================================================

    public LoginBean() {
            initialize();
    }
    
@PostConstruct
    public void initialize() {
        utente = new Persona();
        String mese = "", giorno = "";

        if ( (data.get(Calendar.MONTH)+1) < 10 )					// MESE
            mese = "0"+(data.get(Calendar.MONTH)+1);
        else 
            mese = ""+(data.get(Calendar.MONTH)+1);

        if ( data.get(Calendar.DAY_OF_MONTH) < 10 )					// GIORNO
            giorno = "0"+ data.get(Calendar.DAY_OF_MONTH);
        else 
            giorno = ""+ data.get(Calendar.DAY_OF_MONTH);

        dataI = data.get(Calendar.YEAR) +"-"+ mese +"-01";
        dataF = data.get(Calendar.YEAR) +"-"+ mese +"-"+ giorno;
        dataInizioAccessi = data.get(Calendar.YEAR) +"-01-01";
        dataFineAccessi = dataF;

        try {	
            this.ds = new DataSource();
        } catch( ClassNotFoundException e ){	
            this.ds = null;	
        }
    }

    public List<Impianto> getImpianti() {
        if( this.ds != null ){
            listaImpianti = ds.getImpianti();
        }
        return listaImpianti;
    }

    public List<Clienti> getClienti() {
        if( this.ds != null ){
            listaClienti = ds.getClienti();
        }
        return listaClienti;
    }

    public List<Clienti> getClientiEsterni() {
        if( this.ds != null ){
            listaClientiEsterni = ds.getClientiEsterni(getImpianto());
        }
        return listaClientiEsterni;
    }

    public List<Persona> getPersonale() {
        if( this.ds != null ){
            listaPersonale = ds.getPersonale(getImpianto());
        }
        return listaPersonale;
    }

    public void setPersonaleOggi( List<Persona> listaPersonaleOggi ) {
        this.listaPersonaleOggi = listaPersonaleOggi; 
    }

    public List<Persona> getPersonaleOggi() {
        return listaPersonaleOggi; 
    }

    public String registraTurni() {
        int matricola;
        message = "";
        String ok = "";
        String ko = "";
        for (int i=0; i<listaPersonaleOggi.size(); i++) {
            matricola = Integer.parseInt(""+listaPersonaleOggi.get(i));
            if(!ds.registraTurno(matricola, getImpianto(), getDataOggi()))
                ko += matricola+", ";
            else
                ok += matricola+", ";
        }
        if(!ok.equals(""))
            FacesContext.getCurrentInstance().addMessage("notific", new FacesMessage("Turni utente/i n°"+ok+" inseriti con successo!"));
        if(!ko.equals(""))
            FacesContext.getCurrentInstance().addMessage("error", new FacesMessage("Turni utente/i n°"+ko+" già presenti!"));
        return "";
    }

    public String iscriviCliente() throws ClassNotFoundException {
        if(ds.iscriviCliente(clienteSel, getImpianto()))
            FacesContext.getCurrentInstance().addMessage("notific", new FacesMessage("Cliente iscritto con successo!"));
        else
            FacesContext.getCurrentInstance().addMessage("error", new FacesMessage("Errore durante l'iscrizione!"));
        clienteSel = 0;
        return "";
    }

    public List<Clienti> getAccessi() {
        if( this.ds != null ){
            listaClienti = ds.getAccessi(clienteSelListaAcc, dataInizioAccessi, dataFineAccessi, getImpianto());
        }
        return listaClienti;
    }

    public List<Clienti> getClientiImpianto() {
        if( this.ds != null ){
            clientiImpianto = ds.getClientiImpianto(getImpianto());
        }
        return clientiImpianto;
    }

    public String filtraAccessi() {
        return "";
    }

    public List<Clienti> getClientiAccessi() {
        if( this.ds != null ){
            clientiAccessi = ds.getClientiAccessi(getImpianto());
        }
        return clientiAccessi;
    }

    public String ricercaIngressi() throws ClassNotFoundException {
        if( this.ds != null ){
            listaAbbonamentiCliente = ds.getAbbonamentiCliente(clienteSelNuovoAcc, dataF, getImpianto());
        }
        return "";
    }

    public List<Clienti> getAbbonamenti() {
        return listaAbbonamentiCliente;
    }

    public void setAbbonamenti( List<Clienti> listaAbbonamentiCliente) {
        this.listaAbbonamentiCliente = listaAbbonamentiCliente;
    }

    public String inserisciIngresso(int codBiglietto, char tipoBiglietto) throws ClassNotFoundException {
        data = Calendar.getInstance();
        String mese = "", giorno = "";

        if ( (data.get(Calendar.MONTH)+1) < 10 )
            mese = "0"+(data.get(Calendar.MONTH)+1);
        else
            mese = ""+(data.get(Calendar.MONTH)+1);

        if ( data.get(Calendar.DAY_OF_MONTH) < 10 )
            giorno = "0"+ data.get(Calendar.DAY_OF_MONTH);
        else
            giorno = ""+ data.get(Calendar.DAY_OF_MONTH);

        if ( data.get(Calendar.HOUR_OF_DAY) < 10 )
            ora = "0"+ data.get(Calendar.HOUR_OF_DAY);
        else
            ora = ""+ data.get(Calendar.HOUR_OF_DAY);

        if ( data.get(Calendar.MINUTE) < 10 )
            ora = ora+":0"+ data.get(Calendar.MINUTE);
        else
            ora = ora+":"+ data.get(Calendar.MINUTE);

        dataOggi = data.get(Calendar.YEAR) +"-"+ mese +"-"+ giorno;

        if( this.ds != null ){
            if( ds.inserisciIngresso(codBiglietto, tipoBiglietto, getImpianto(), dataOggi, ora)){
                ricercaIngressi();
                FacesContext.getCurrentInstance().addMessage("notific", new FacesMessage("Ingresso effettuato con successo!"));
                return "";
            }
        }
        FacesContext.getCurrentInstance().addMessage("error", new FacesMessage("Errore, impossibile effettuare l'accesso!"));
        return "";	
    }

  // === Methods get Form ===============================================================

    public int getClienteSel() {
        return clienteSel; 
    }
    public void setClienteSel(int clienteSel) {
        this.clienteSel = clienteSel; 
    }
    public int getClienteSelListaAcc() {
        return clienteSelListaAcc; 
    }
    public void setClienteSelListaAcc(int clienteSelListaAcc) {
        this.clienteSelListaAcc = clienteSelListaAcc; 
    }
    public int getClienteSelNuovoAcc() {
        return clienteSelNuovoAcc; 
    }
    public void setClienteSelNuovoAcc(int clienteSelNuovoAcc) {
        this.clienteSelNuovoAcc = clienteSelNuovoAcc; 
    }
    
    public int getMatricola() {
        return utente.getMatricola(); 
    }
    public String getNomeCognome() {
        return utente.getNome().toUpperCase()+" "+utente.getCognome().toUpperCase(); 
    }
    public void setMatricola(int newValue) {
        utente.setMatricola(newValue); 
    }
    public String getPassword() {
        return utente.getPassword(); 
    }
    public void setPassword(String newValue) {
        utente.setPassword(newValue); 
    }
    public String getImpianto() {
        return utente.getNomeImpianto(); 
    }
    public void setImpianto(String newValue) {
        utente.setNomeImpianto(newValue); 
    }
    public String getDataChiusura() {
        return utente.getDataChiusuraImpianto(); 
    }
    public void setDataChiusura(String newValue) {
        utente.setDataChiusuraImpianto(newValue); 
    }
    public String getDataI() {
        return dataI; 
    }
    public void setDataI(String newValue) {
        if(!newValue.equals(""))
            dataI = newValue;
    }
    public String getDataF() {
        return dataF; 
    }
    public void setDataF(String newValue) {
        if(!newValue.equals(""))
            dataF = newValue; 
    }
    public String getDataInizioAccessi() {
        return dataInizioAccessi; 
    }
    public void setDataInizioAccessi(String newValue) { 		
        if(!newValue.equals(""))
            dataInizioAccessi = newValue; 
    }
    public String getDataFineAccessi() {
        return dataFineAccessi; 
    }
    public void setDataFineAccessi(String newValue) { 			
        if(!newValue.equals(""))
            dataFineAccessi = newValue; 
    }
    public String getMessage() {
        return message; 
    }
    public void setMessage(String message) {
        this.message = message; 
    }
    public Impianto getImpiantoSel(){
        return impiantoSel; 
    }
    public String impiantoSel(Impianto newValue) {
        impiantoSel = newValue;
        return "impianto";
    }
    public String cercaIngressi() throws ClassNotFoundException {
        impiantoSel.getListaGiorni(dataI, dataF);
        return "";
    }
    public String nuovoBiglietto(char tipo) throws ClassNotFoundException {
        String dataOggi = getDataOggi();
        int prezzo, codBiglietto;
        if( tipo == 'a' ){
            prezzo = 400;
            codBiglietto = ds.nuovoBiglietto(clienteSelNuovoAcc, tipo, prezzo, dataOggi, getDataChiusura(), 0, 0);
        }else if( tipo == 'c' ){
            prezzo = 200;
            codBiglietto = ds.nuovoBiglietto(clienteSelNuovoAcc, tipo, prezzo, "", "", 50, 50);
        }else if( tipo == 'd' ){
            prezzo = 40;
            codBiglietto = ds.nuovoBiglietto(clienteSelNuovoAcc, tipo, prezzo, "", "", 10, 10);
        }else if( tipo == 's' ){
            prezzo = 5;
            codBiglietto = ds.nuovoBiglietto(clienteSelNuovoAcc, tipo, prezzo, "", "", 0, 0);
        }else {
            FacesContext.getCurrentInstance().addMessage("error", new FacesMessage("Errore, impossibile effettuare l'accesso!"));
            return "";
        }
        inserisciIngresso(codBiglietto, tipo);
        //message = ""+tipo+" "+clienteSel+" "+getImpianto()+" "+dataOggi+" "+getDataChiusura()+" "+codBiglietto;
        return "";
    }
    
    public String chiudiGiornata(){
        if(!ds.ingressiOggi( getDataOggi(), getImpianto() ))
            FacesContext.getCurrentInstance().addMessage("error", new FacesMessage("Errore, impossibile chiudere la Giornata!"));
        else
            FacesContext.getCurrentInstance().addMessage("notific", new FacesMessage("Giorno chiuso con successo!"));
        return "";
    }
    
    public String getDataOggi() {
        data = Calendar.getInstance();
        String mese = "", giorno = "";

        if ( (data.get(Calendar.MONTH)+1) < 10 )					// MESE
            mese = "0"+(data.get(Calendar.MONTH)+1);
        else 
            mese = ""+(data.get(Calendar.MONTH)+1);

        if ( data.get(Calendar.DAY_OF_MONTH) < 10 )					// GIORNO
            giorno = "0"+ data.get(Calendar.DAY_OF_MONTH);
        else 
            giorno = ""+ data.get(Calendar.DAY_OF_MONTH);
        return data.get(Calendar.YEAR) +"-"+ mese +"-"+giorno;
    }
    
    public String loginProject() {
        utente = ds.login(getMatricola(), getPassword());
        if (utente.getMatricola() != 0) {					
            // get Http Session and store username
            HttpSession session = Util.getSession();
            session.setAttribute("username", utente.getNome());
            return "area-riservata";
        } else {
            FacesContext.getCurrentInstance().addMessage(null, new FacesMessage("Username e/o Password errate!"));
            
            return "index";
        }
    }

    public String logout() {
    	HttpSession session = Util.getSession();
    	session.invalidate();
    	return "index";
    }

}
