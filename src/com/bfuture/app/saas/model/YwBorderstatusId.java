package com.bfuture.app.saas.model;

// Generated 2011-12-7 14:38:38 by Hibernate Tools 3.2.2.GA

import javax.persistence.Column;
import javax.persistence.Embeddable;

import com.bfuture.app.basic.model.BaseObject;

/**
 * YwBorderstatusId generated by hbm2java
 */
@Embeddable
public class YwBorderstatusId extends BaseObject implements java.io.Serializable {

	private String bohsgcode; // 实例编码
	private String bohbillno; // 订单编号
	private String bohshmfid; // 门店标号

	public YwBorderstatusId() {
	}

	public YwBorderstatusId(String bohsgcode, String bohbillno, String bohshmfid) {
		this.bohsgcode = bohsgcode;
		this.bohbillno = bohbillno;
		this.bohshmfid = bohshmfid;
	}

	@Column(name = "BOHSGCODE", nullable = false, length = 30)
	public String getBohsgcode() {
		return this.bohsgcode;
	}

	public void setBohsgcode(String bohsgcode) {
		this.bohsgcode = bohsgcode;
	}

	@Column(name = "BOHBILLNO", nullable = false, length = 32)
	public String getBohbillno() {
		return this.bohbillno;
	}

	public void setBohbillno(String bohbillno) {
		this.bohbillno = bohbillno;
	}

	@Column(name = "BOHSHMFID", nullable = false, length = 30)
	public String getBohshmfid() {
		return this.bohshmfid;
	}

	public void setBohshmfid(String bohshmfid) {
		this.bohshmfid = bohshmfid;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof YwBorderstatusId))
			return false;
		YwBorderstatusId castOther = (YwBorderstatusId) other;

		return ((this.getBohsgcode() == castOther.getBohsgcode()) || (this
				.getBohsgcode() != null
				&& castOther.getBohsgcode() != null && this.getBohsgcode()
				.equals(castOther.getBohsgcode())))
				&& ((this.getBohbillno() == castOther.getBohbillno()) || (this
						.getBohbillno() != null
						&& castOther.getBohbillno() != null && this
						.getBohbillno().equals(castOther.getBohbillno())))
				&& ((this.getBohshmfid() == castOther.getBohshmfid()) || (this
						.getBohshmfid() != null
						&& castOther.getBohshmfid() != null && this
						.getBohshmfid().equals(castOther.getBohshmfid())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result
				+ (getBohsgcode() == null ? 0 : this.getBohsgcode().hashCode());
		result = 37 * result
				+ (getBohbillno() == null ? 0 : this.getBohbillno().hashCode());
		result = 37 * result
				+ (getBohshmfid() == null ? 0 : this.getBohshmfid().hashCode());
		return result;
	}

	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return null;
	}

}