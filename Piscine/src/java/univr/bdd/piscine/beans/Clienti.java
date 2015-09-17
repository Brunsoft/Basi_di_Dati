package univr.bdd.piscine.beans;

import javax.annotation.PostConstruct;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import java.io.Serializable;
import java.util.Collections;
import java.util.List;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Date;
import java.sql.Time;
import javax.faces.application.FacesMessage;
import javax.faces.context.FacesContext;

@ManagedBean(name = "clienti")
@SessionScoped
public class Clienti {

  // === Properties ============================================================

	private DataSource ds;

	private int codCliente;
	private String nomeCliente;
	private String cognomeCliente;
	private char tipoDocumento;
	private String numeroDocumento;

	private int codBiglietto;
	private char tipoBiglietto;
	private int costoBiglietto;
	private Date dataInizioAbbonamento;
	private Date dataFineAbbonamento;
	private int totaleIngressi;
	private int ingressiRimasti;

	private String nomeImpianto;
	private Date dataEntrata;
	private Time oraEntrata;
	private Time oraUscita;
	private List<Character> possibiliTipi = new ArrayList<Character>();

  // ===  Methods  =================================================================

	public Clienti() {
		possibiliTipi.add( 'c' );
		possibiliTipi.add( 'p' );
	}
 
@PostConstruct
	public void initialize() {
		codCliente = 0;
		nomeCliente = "";
		cognomeCliente = "";
		tipoDocumento = '\0';
		numeroDocumento = "";
	}

	public String insertUtente( String impianto ) throws ClassNotFoundException {
		ds = new DataSource();
		if(ds.insertNewCliente(this)){
			codCliente = ds.getCodiceCliente(this);
			if (codCliente != 0){
				if(ds.iscriviCliente(codCliente, impianto)){
					initialize();
                                        FacesContext.getCurrentInstance().addMessage("notific", new FacesMessage("Cliente iscritto con successo!"));
					return "";
				}
			}
		}
                FacesContext.getCurrentInstance().addMessage("error", new FacesMessage("Errore durante l'iscrizione!"));
		return "";

	}

  // === Methods get() ===============================================================

	public int getCodCliente() {
		return codCliente; 
	}
	public String getNomeCliente() {
		return nomeCliente; 
	}
	public String getCognomeCliente() {
		return cognomeCliente;
	}
	public char getTipoDocumento() {
		return tipoDocumento; 
	}
	public List<Character> getPossibiliTipi() {
		return possibiliTipi; 
	}
	public String getNumeroDocumento() {
		return numeroDocumento; 
	}
	public char getTipoBiglietto() {
		return tipoBiglietto; 
	}
        public String getTipoBigliettoString() {
		if(tipoBiglietto == 'a')
                    return "Abbonamento";
                if(tipoBiglietto == 'd')
                    return "10 Accessi";
                if(tipoBiglietto == 'c')
                    return "50 Accessi";
                if(tipoBiglietto == 'b')
                    return "Biglietto Singolo";
                return "";
	}
	public String getNomeImpianto() {
		return nomeImpianto; 
	}
	public Date getDataEntrata() {
		return dataEntrata; 
	}
	public Time getOraEntrata() {	
		return oraEntrata;
	}
	public Time getOraUscita() {
		return oraUscita; 
	}
	public int getCodBiglietto() {
		return codBiglietto;
	}
	public int getCostoBiglietto() {
		return costoBiglietto;
	}
	public Date getDataInizioAbbonamento() {
		return dataInizioAbbonamento;
	}
	public Date getDataFineAbbonamento() {
		return dataFineAbbonamento;
	}
	public int getTotaleIngressi() {
		return totaleIngressi;
	}
	public int getIngressiRimasti() {
		return ingressiRimasti;
	}

  // === Methods set()===============================================================

	public void setCodCliente( int codCliente ) {
		this.codCliente = codCliente; 
	}
	public void setNomeCliente( String nomeCliente ) {
		this.nomeCliente = nomeCliente; 
	}
	public void setCognomeCliente( String cognomeCliente ) {
		this.cognomeCliente = cognomeCliente;
	}
	public void setTipoDocumento( char tipoDocumento ) {
		this.tipoDocumento = tipoDocumento; 
	}
	public void setNumeroDocumento( String numeroDocumento ) {
		this.numeroDocumento = numeroDocumento; 
	}
	public void setTipoBiglietto( char tipoBiglietto ) {
		this.tipoBiglietto = tipoBiglietto; 
	}
	public void setNomeImpianto( String nomeImpianto ) {
		this.nomeImpianto = nomeImpianto; 
	}
	public void setDataEntrata( Date dataEntrata ) {
		this.dataEntrata = dataEntrata; 
	}
	public void setOraEntrata( Time oraEntrata ) {	
		this.oraEntrata = oraEntrata;
	}
	public void setOraUscita( Time oraUscita ) {
		this.oraUscita = oraUscita; 
	}
	public void setCodBiglietto( int codBiglietto ) {
		this.codBiglietto = codBiglietto;
	}
	public void setDataInizioAbbonamento( Date dataInizioAbbonamento ) {
		this.dataInizioAbbonamento = dataInizioAbbonamento;
	}
	public void setDataFineAbbonamento( Date dataFineAbbonamento ) {
		this.dataFineAbbonamento = dataFineAbbonamento;
	}
	public void setCostoBiglietto( int costoBiglietto ) {
		this.costoBiglietto = costoBiglietto;
	}
	public void setTotaleIngressi( int totaleIngressi ) {
		this.totaleIngressi = totaleIngressi;
	}
	public void setIngressiRimasti( int ingressiRimasti ) {
		this.ingressiRimasti = ingressiRimasti;
	}
}
