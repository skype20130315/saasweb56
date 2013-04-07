package com.bfuture.app.saas.model;

// Generated 2011-3-8 10:36:54 by Hibernate Tools 3.2.2.GA

import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 * SysSurlId generated by hbm2java
 */
@Embeddable
public class SysSurlId implements java.io.Serializable {

	private String rlcode;
	private String sucode;
	private String sgcode;

	public SysSurlId() {
	}

	public SysSurlId(String rlcode, String sucode) {
		this.rlcode = rlcode;
		this.sucode = sucode;
	}

	@Column(name = "RLCODE", nullable = false, length = 30)
	public String getRlcode() {
		return this.rlcode;
	}

	public void setRlcode(String rlcode) {
		this.rlcode = rlcode;
	}

	@Column(name = "SUCODE", nullable = false, length = 30)
	public String getSucode() {
		return this.sucode;
	}

	public void setSucode(String sucode) {
		this.sucode = sucode;
	}	
	
	@Column(name = "SGCODE", nullable = false, length = 30)
	public String getSgcode() {
		return sgcode;
	}

	public void setSgcode(String sgcode) {
		this.sgcode = sgcode;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof SysSurlId))
			return false;
		SysSurlId castOther = (SysSurlId) other;

		return ((this.getRlcode() == castOther.getRlcode()) || (this
				.getRlcode() != null
				&& castOther.getRlcode() != null && this.getRlcode().equals(
				castOther.getRlcode())))
				&& ((this.getSucode() == castOther.getSucode()) || (this
						.getSucode() != null
						&& castOther.getSucode() != null && this.getSucode()
						.equals(castOther.getSucode())))
				&& ((this.getSgcode() == castOther.getSgcode()) || (this
						.getSgcode() != null
						&& castOther.getSgcode() != null && this.getSgcode()
						.equals(castOther.getSgcode())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result
				+ (getRlcode() == null ? 0 : this.getRlcode().hashCode());
		result = 37 * result
				+ (getSucode() == null ? 0 : this.getSucode().hashCode());
		result = 37 * result
				+ (getSgcode() == null ? 0 : this.getSgcode().hashCode());
		return result;
	}

}