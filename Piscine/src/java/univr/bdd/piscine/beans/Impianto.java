package univr.bdd.piscine.beans;

import javax.annotation.PostConstruct;
import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;
import java.io.Serializable;
import java.util.Collections;
import java.util.List;
import java.util.Date;
import java.util.ArrayList;

@ManagedBean(name = "impianto")
@SessionScoped
public class Impianto {

  // === Properties ============================================================

	private DataSource ds;
	private String nome;
	private Date dataA;
	private Date dataC;
	private String comune;
	private String indirizzo;
	private boolean tipoV;
	private boolean tipoC;
	private boolean tipoT;
	private boolean tipoB;
	private int image;
	private List<Piscina> listaPiscine = new ArrayList<Piscina>();
	private List<Giorno> listaGiorni = new ArrayList<Giorno>();
	private int totaleIngressi;


  // ===  Methods  =================================================================

	public Impianto() {}
 
@PostConstruct
	public void initialize() {
		nome = "";
		comune = "";
		indirizzo = "";
		tipoV = false;
		tipoC = false;
		tipoT = false;
		tipoB = false;
		totaleIngressi = 0;
	}

		/*public String registry() throws ClassNotFoundException {
			ds = new DataSource();
			if(ds.insertNewCave(this)){
				initialize();
				return "";
			}else
				return "";
		}*/
  // === Methods get() ===============================================================

	public String getNome() {		return nome; }
	public Date getDataA() {		return dataA; }
	public Date getDataC() {		return dataC; }
	public String getComune() {			return comune; }
	public String getIndirizzo() {		return indirizzo; }

	public String getImage() {
		return "intro"+(indirizzo+nome).length()%8;
	}

	public List<Piscina> getPiscine(){	
		return listaPiscine; 
	}

	public List<Giorno> getGiorni(){	
		return listaGiorni; 
	}

	public String getTipoV() {		
		if(tipoV)	return "visible";
		else		return "hidden"; 
	}
	public String getTipoC() {		
		if(tipoC)	return "visible";
		else		return "hidden"; 
	}
	public String getTipoT() {		
		if(tipoT)	return "visible";
		else		return "hidden"; 
	}
	public String getTipoB() {		
		if(tipoB)	return "visible";
		else		return "hidden"; 
	}
	public int getTotaleIngressi() {
		return totaleIngressi;
	}

	public void getListaPiscine() throws ClassNotFoundException {
		ds = new DataSource();
		listaPiscine = ds.getPiscineImpianto(this);
		for(int i=0; i<listaPiscine.size(); i++){
			if(listaPiscine.get(i).getTipo() == 'v')
				tipoV = true;
			else if(listaPiscine.get(i).getTipo() == 'c')
				tipoC = true;
			else if(listaPiscine.get(i).getTipo() == 'b')
				tipoB = true;
			else if(listaPiscine.get(i).getTipo() == 't')
				tipoT = true;
		}
	}

	public void getListaGiorni() throws ClassNotFoundException {
		ds = new DataSource();
		listaGiorni = ds.getGiorniImpianto(this, "", "");
		for(int i=0; i<listaGiorni.size(); i++){
			totaleIngressi += listaGiorni.get(i).getNingr();
		}
	}

	public void getListaGiorni(String dataI, String dataF) throws ClassNotFoundException {
		ds = new DataSource();
		listaGiorni = ds.getGiorniImpianto(this, dataI, dataF);
	}

  // === Methods set()===============================================================

	public void setNome( String nome ) {		this.nome = nome; }
	public void setDataA( Date dataA ) {		this.dataA = dataA; }
	public void setDataC( Date dataC ) {		this.dataC = dataC; }
	public void setComune( String comune ) {	this.comune = comune; }
	public void setIndirizzo( String indirizzo ) {		this.indirizzo = indirizzo; }
	public void setPiscine( List<Piscina> listaPiscine ){	this.listaPiscine = listaPiscine; }
	public void setTotaleIngressi ( int totaleIngressi ){ 	this.totaleIngressi = totaleIngressi; }
}
