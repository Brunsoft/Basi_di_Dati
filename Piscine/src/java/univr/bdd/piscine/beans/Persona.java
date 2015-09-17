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

@ManagedBean(name = "persona")
@SessionScoped
public class Persona {

  // === Properties ============================================================

	private DataSource ds;

	private int matricola;
	private String nome;
	private String cognome;
	private String password;
	private Date dataNascita;
	private String nomeImpianto;
	private String dataChiusuraImpianto;

  // ===  Methods  =================================================================

	public Persona() {}
 
@PostConstruct
	public void initialize() {
		matricola = 0;
		nome = "";
		cognome = "";
		password = "";
		nomeImpianto = "";
	}

  // === Methods get() ===============================================================
	
	public int getMatricola() {
		return matricola; 
	}	
	public String getNome() {
		return nome; 
	}
	public String getCognome() {
		return cognome; 
	}
	public String getPassword() {
		return password;
	}
	public Date getDataNascita() {
		return dataNascita; 
	}
	public String getNomeImpianto() {
		return nomeImpianto;
	}
	public String getDataChiusuraImpianto() {
		return dataChiusuraImpianto;
	}

  // === Methods set()===============================================================

	public void setMatricola( int matricola ) {
		this.matricola = matricola; 
	}	
	public void setNome( String nome ) {
		this.nome = nome; 
	}
	public void setCognome( String cognome ) {
		this.cognome = cognome; 
	}
	public void setPassword( String password ) {
		this.password = password;
	}
	public void setDataNascita( Date dataNascita ) {
		this.dataNascita = dataNascita; 
	}
	public void setNomeImpianto( String nomeImpianto ) {
		this.nomeImpianto = nomeImpianto;
	}
	public void setDataChiusuraImpianto( String dataChiusuraImpianto ) {
		this.dataChiusuraImpianto = dataChiusuraImpianto;
	}
}
