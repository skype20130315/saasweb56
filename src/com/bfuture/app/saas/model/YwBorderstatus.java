package com.bfuture.app.saas.model;

// Generated 2011-12-7 14:38:38 by Hibernate Tools 3.2.2.GA

import java.util.Date;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Transient;

import com.bfuture.app.basic.model.BaseObject;

/**
 * YwBorderstatus generated by hbm2java
 * 订单状态表
 */
@Entity
@Table(name = "YW_BORDERSTATUS")
public class YwBorderstatus extends BaseObject implements java.io.Serializable {

	private YwBorderstatusId id;  // 实例编码(bohsgcode) 订单编号(bohbillno) 门店编号(bohshmfid)
	private String bohstatus;	
	private Date bohtime; 
	private String bohmemo;
	private String temp1;
	private String temp2;
	private String temp3;
	private String temp4;
	private String temp5;
	
	// 辅助字段
	private String bohsgcode; // 实例编码
	private String bohbillno; // 订单编号
	private String bohshmfid; // 门店标号

	public YwBorderstatus() {
	}

	public YwBorderstatus(YwBorderstatusId id) {
		this.id = id;
	}

	public YwBorderstatus(YwBorderstatusId id, String bohstatus,
			Date bohtime, String bohmemo, String temp1, String temp2,
			String temp3, String temp4, String temp5) {
		this.id = id;
		this.bohstatus = bohstatus;
		this.bohtime = bohtime;
		this.bohmemo = bohmemo;
		this.temp1 = temp1;
		this.temp2 = temp2;
		this.temp3 = temp3;
		this.temp4 = temp4;
		this.temp5 = temp5;
	}

	@EmbeddedId
	@AttributeOverrides( {
			@AttributeOverride(name = "bohsgcode", column = @Column(name = "BOHSGCODE", nullable = false, length = 30)),
			@AttributeOverride(name = "bohbillno", column = @Column(name = "BOHBILLNO", nullable = false, length = 32)),
			@AttributeOverride(name = "bohshmfid", column = @Column(name = "BOHSHMFID", nullable = false, length = 30)) })
	public YwBorderstatusId getId() {
		return this.id;
	}

	public void setId(YwBorderstatusId id) {
		this.id = id;
	}

	@Column(name = "BOHSTATUS", length = 1)
	public String getBohstatus() {
		return this.bohstatus;
	}

	public void setBohstatus(String bohstatus) {
		this.bohstatus = bohstatus;
	}

	@Column(name = "BOHTIME")
	public Date getBohtime() {
		return this.bohtime;
	}

	public void setBohtime(Date bohtime) {
		this.bohtime = bohtime;
	}

	@Column(name = "BOHMEMO", length = 300)
	public String getBohmemo() {
		return this.bohmemo;
	}

	public void setBohmemo(String bohmemo) {
		this.bohmemo = bohmemo;
	}

	@Column(name = "TEMP1", length = 100)
	public String getTemp1() {
		return this.temp1;
	}

	public void setTemp1(String temp1) {
		this.temp1 = temp1;
	}

	@Column(name = "TEMP2", length = 100)
	public String getTemp2() {
		return this.temp2;
	}

	public void setTemp2(String temp2) {
		this.temp2 = temp2;
	}

	@Column(name = "TEMP3", length = 100)
	public String getTemp3() {
		return this.temp3;
	}

	public void setTemp3(String temp3) {
		this.temp3 = temp3;
	}

	@Column(name = "TEMP4", length = 100)
	public String getTemp4() {
		return this.temp4;
	}

	public void setTemp4(String temp4) {
		this.temp4 = temp4;
	}

	@Column(name = "TEMP5", length = 100)
	public String getTemp5() {
		return this.temp5;
	}

	public void setTemp5(String temp5) {
		this.temp5 = temp5;
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

	// 辅助字段开始
	@Transient
	public String getBohsgcode() {
		return bohsgcode;
	}

	public void setBohsgcode(String bohsgcode) {
		this.bohsgcode = bohsgcode;
	}

	@Transient
	public String getBohbillno() {
		return bohbillno;
	}

	public void setBohbillno(String bohbillno) {
		this.bohbillno = bohbillno;
	}

	@Transient
	public String getBohshmfid() {
		return bohshmfid;
	}

	public void setBohshmfid(String bohshmfid) {
		this.bohshmfid = bohshmfid;
	}
	// 辅助字段结束
	

}