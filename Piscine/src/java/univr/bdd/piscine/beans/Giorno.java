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

@ManagedBean(name = "giorno")
@SessionScoped
public class Giorno {

  // === Properties ============================================================

	private DataSource ds;
	private Date data;
	private Time oraA;
	private Time oraC;
	private int nIngr;

  // ===  Methods  =============================================================

	public Giorno() {}
 
@PostConstruct
	public void initialize() {
            nIngr = 0;
	}

  // === Methods get() =========================================================

	public Date getData() {     return data; }
	public Time getOraA() {     return oraA; }
	public Time getOraC() {     return oraC; }
	public int getNingr() {     return nIngr; }

  // === Methods set()==========================================================

	public void setData(Date data) {    this.data = data; }
	public void setOraA(Time oraA) {    this.oraA = oraA; }
	public void setOraC(Time oraC) {    this.oraC = oraC; }
	public void setNingr(int nIngr) {   this.nIngr = nIngr; }
}
