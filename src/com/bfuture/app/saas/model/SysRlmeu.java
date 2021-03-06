package com.bfuture.app.saas.model;

// Generated 2011-3-17 7:22:25 by Hibernate Tools 3.2.2.GA

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Transient;

import com.bfuture.app.basic.model.BaseObject;

/**
 * SysRlmeu generated by hbm2java
 */
@Entity
@Table(name = "SYS_RLMEU")
public class SysRlmeu extends BaseObject implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7800068303370622188L;
	private SysRlmeuId id;
	private String sgcode;
	private String rlcode;
	private String meucode;

	public SysRlmeu() {
	}

	public SysRlmeu(SysRlmeuId id) {
		this.id = id;
	}

	public SysRlmeu(SysRlmeuId id, String sgcode) {
		this.id = id;
		this.sgcode = sgcode;
	}

	@EmbeddedId
	@AttributeOverrides( {
			@AttributeOverride(name = "rlcode", column = @Column(name = "RLCODE", nullable = false, length = 30)),
			@AttributeOverride(name = "meucode", column = @Column(name = "MEUCODE", nullable = false, length = 30)) })
	public SysRlmeuId getId() {
		return this.id;
	}

	public void setId(SysRlmeuId id) {
		this.id = id;
	}

	@Column(name = "SGCODE", length = 30)
	public String getSgcode() {
		return this.sgcode;
	}

	public void setSgcode(String sgcode) {
		this.sgcode = sgcode;
	}

	@Override
	public boolean equals(Object o) {
		// TODO Auto-generated method stub
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

	@Transient
	public String getRlcode() {
		return rlcode;
	}

	public void setRlcode(String rlcode) {
		if( id == null ) id = new SysRlmeuId();
		id.setRlcode(rlcode);
		this.rlcode = rlcode;
	}
	
	@Transient
	public String getMeucode() {
		return meucode;
	}

	public void setMeucode(String meucode) {
		if ( id == null ) id = new SysRlmeuId();
		id.setMeucode(meucode);
		this.meucode = meucode;
	}
	
	

}
