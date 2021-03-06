package com.bfuture.app.saas.model;

// Generated 2011-3-3 14:49:18 by Hibernate Tools 3.2.2.GA

import java.util.Date;
import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;
import com.bfuture.app.basic.model.BaseObject;

/**
 * InfSupinfo generated by hbm2java
 */
@Entity
@Table(name = "INF_SUPINFO", schema = "SCMUSER")
public class InfSupinfo extends BaseObject implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8582962273032380009L;
	private InfSupinfoId id;
	private String supname;
	private Date supgxtime;
	private String supfile;
 //	private Date extDate;
	private String supcont;
	private String supcontphone;
	private String supcontemail;
	private String supdutyno;
	private String supfax;
	private String supbank;
	private String supaccount;
	private String supaccountname;
	private String supzip;
	private String suplegal;
	private String supadd;
	private String supsgcode;
	private String supid;
 //	private String supmfid;
 //	private String sutype;
	
	
	public InfSupinfo() {
	}

	public InfSupinfo(InfSupinfoId id) {
		this.id = id;
	}

	public InfSupinfo(InfSupinfoId id, String supname, Date supgxtime,
			String supfile, String supcont, String supcontphone,
			String supcontemail, String supdutyno, String supfax,
			String supbank, String supaccount, String supaccountname,
			String supzip, String suplegal, String supadd) {
		this.id = id;
		this.supname = supname;
		this.supgxtime = supgxtime;
		this.supfile = supfile;
	//	this.extDate = extDate;
		this.supcont = supcont;
		this.supcontphone = supcontphone;
		this.supcontemail = supcontemail;
		this.supdutyno = supdutyno;
		this.supfax = supfax;
		this.supbank = supbank;
		this.supaccount = supaccount;
		this.supaccountname = supaccountname;
		this.supzip = supzip;
		this.suplegal = suplegal;
		this.supadd = supadd;
	}

	@EmbeddedId
	@AttributeOverrides( {
			@AttributeOverride(name = "supsgcode", column = @Column(name = "SUPSGCODE", nullable = false, length = 30)),
			@AttributeOverride(name = "supid", column = @Column(name = "SUPID", nullable = false, length = 24)),
			@AttributeOverride(name = "supmfid", column = @Column(name = "SUPMFID", nullable = false, length = 30)) })
	public InfSupinfoId getId() {
		return this.id;
	}

	public void setId(InfSupinfoId id) {
		this.id = id;
	}

	@Column(name = "SUPNAME", length = 80)
	public String getSupname() {
		return this.supname;
	}

	public void setSupname(String supname) {
		this.supname = supname;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "SUPGXTIME", length = 26)
	public Date getSupgxtime() {
		return this.supgxtime;
	}

	public void setSupgxtime(Date supgxtime) {
		this.supgxtime = supgxtime;
	}

	@Column(name = "SUPFILE", length = 64)
	public String getSupfile() {
		return this.supfile;
	}

	public void setSupfile(String supfile) {
		this.supfile = supfile;
	}

	/*
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "EXT_DATE", length = 26)
	public Date getExtDate() {
		return this.extDate;
	}

	public void setExtDate(Date extDate) {
		this.extDate = extDate;
	}
	*/
	@Column(name = "SUPCONT", length = 30)
	public String getSupcont() {
		return this.supcont;
	}

	public void setSupcont(String supcont) {
		this.supcont = supcont;
	}

	@Column(name = "SUPCONTPHONE", length = 30)
	public String getSupcontphone() {
		return this.supcontphone;
	}

	public void setSupcontphone(String supcontphone) {
		this.supcontphone = supcontphone;
	}

	@Column(name = "SUPCONTEMAIL", length = 50)
	public String getSupcontemail() {
		return this.supcontemail;
	}

	public void setSupcontemail(String supcontemail) {
		this.supcontemail = supcontemail;
	}

	@Column(name = "SUPDUTYNO", length = 80)
	public String getSupdutyno() {
		return this.supdutyno;
	}

	public void setSupdutyno(String supdutyno) {
		this.supdutyno = supdutyno;
	}

	@Column(name = "SUPFAX", length = 30)
	public String getSupfax() {
		return this.supfax;
	}

	public void setSupfax(String supfax) {
		this.supfax = supfax;
	}

	@Column(name = "SUPBANK", length = 200)
	public String getSupbank() {
		return this.supbank;
	}

	public void setSupbank(String supbank) {
		this.supbank = supbank;
	}

	@Column(name = "SUPACCOUNT", length = 100)
	public String getSupaccount() {
		return this.supaccount;
	}

	public void setSupaccount(String supaccount) {
		this.supaccount = supaccount;
	}

	@Column(name = "SUPACCOUNTNAME", length = 200)
	public String getSupaccountname() {
		return this.supaccountname;
	}

	public void setSupaccountname(String supaccountname) {
		this.supaccountname = supaccountname;
	}

	@Column(name = "SUPZIP", length = 30)
	public String getSupzip() {
		return this.supzip;
	}

	public void setSupzip(String supzip) {
		this.supzip = supzip;
	}

	@Column(name = "SUPLEGAL", length = 80)
	public String getSuplegal() {
		return this.suplegal;
	}

	public void setSuplegal(String suplegal) {
		this.suplegal = suplegal;
	}

	@Column(name = "SUPADD", length = 200)
	public String getSupadd() {
		return this.supadd;
	}

	public void setSupadd(String supadd) {
		this.supadd = supadd;
	}

	@Transient
	public String getSupsgcode() {
		return id != null ? id.getSupsgcode() : supsgcode;
	}

	public void setSupsgcode(String supsgcode) {
		this.supsgcode = supsgcode;
	}

	@Transient
	public String getSupid() {
		return id != null ? id.getSupid() : supid;
	}

	public void setSupid(String supid) {
		this.supid = supid;
	}
	/*
	@Transient
	public String getSupmfid() {
		return id != null ? id.getSupmfid() : supmfid;
	}

	public void setSupmfid(String supmfid) {
		this.supmfid = supmfid;
	}
	*/
	@Override
	public boolean equals(Object o) {		
		return false;
	}

	@Override
	public int hashCode() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return null;
	}
	/*
	@Transient
	public String getSutype() {
		return sutype;
	}

	public void setSutype(String sutype) {
		this.sutype = sutype;
	}
	*/
	
}
