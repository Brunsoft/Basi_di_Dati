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

@ManagedBean(name = "piscina")
@SessionScoped
public class Piscina {

  // === Properties ============================================================

	private DataSource ds;
	private int cod;
	private Date dataA;
	private Date dataC;
	private Time oraA;
	private Time oraC;
	private char tipo;

  // ===  Methods  =================================================================

	public Piscina() {}
 
@PostConstruct
	public void initialize() {
		cod = 0;
	}

  // === Methods get() ===============================================================

	public int getCod() {				return cod; }
	public Date getDataA() {			return dataA; }
	public Date getDataC() {			return dataC; }
	public Time getOraA() {				return oraA; }
	public Time getOraC() {				return oraC; }
	public char getTipo() {				return tipo; }
        public String getTipoString() {
            if(tipo == 'v')
                return "Piscina 25 m";
            if(tipo == 'c')
                return "Piscina 50 m";
            if(tipo == 't')
                return "Piscina Tuffi";
            if(tipo == 'b')
                return "Piscina Bambini";
            return "";
        }

  // === Methods set()===============================================================

	public void setCod(int cod) {				this.cod = cod; }
	public void setDataA(Date dataA) {			this.dataA = dataA; }
	public void setDataC(Date dataC) {			this.dataC = dataC; }
	public void setOraA(Time oraA) {			this.oraA = oraA; }
	public void setOraC(Time oraC) {			this.oraC = oraC; }
	public void setTipo(char tipo) {			this.tipo = tipo; }
}
