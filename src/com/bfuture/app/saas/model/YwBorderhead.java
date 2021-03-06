package com.bfuture.app.saas.model;

// Generated 2011-12-7 14:38:38 by Hibernate Tools 3.2.2.GA

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
 * YwBorderhead generated by hbm2java
 * 订单头表(共21个字段)
 */
@Entity
@Table(name = "YW_BORDERHEAD")
public class YwBorderhead extends BaseObject implements java.io.Serializable {

	private YwBorderheadId id;  	// 实例编码(bohsgcode) 订单编号(bohbillno) 门店编号(bohmfid)
	private String bohsupid; 		// 供应商编号
	private String bohshmfid; 		// 门店号
	private Date bohdhrq; 			// 订货日期
	private Date bohjhrq; 			// 交货日期
	private Date bohshtime; 	// 审核日期
	private Date bohqxtime; 	// 有效日期
	private String bohhtno; 		// 合同号
	private String bohrkdd; 		// 入库单号
	private String bohjyfs; 		// 交易方式
	private String bohgz;   		// 柜组
	private String bohmemo; 		// 备注
	private String temp1;			//订货人
	private String temp2;			//供应商地址
	private String temp3;			//电脑员
	private String temp4;			//审核人
	private String temp5;			//打印次数
	private Date bohtime;
	private String bohfile;
	
	// 辅助字段(封装查询条件)
	private String bohsgcode; // 实例编码
	private String bohbillno; // 订单编号
	private String bohstatus; // 订单状态
	private String startDate; // 开始时间
	private String endDate;   // 结束时间
	private String bohmfid;   // 门店编号
	private String state;     // 订单状态（金凯达3016）
	
	
	public YwBorderhead() {
	}

	public YwBorderhead(YwBorderheadId id) {
		this.id = id;
	}

	public YwBorderhead(YwBorderheadId id, String bohsupid, String bohshmfid,
			Date bohdhrq, Date bohjhrq, Date bohshtime,
			Date bohqxtime, String bohhtno, String bohrkdd,
			String bohjyfs, String bohgz, String bohmemo, String temp1,
			String temp2, String temp3, String temp4, String temp5,
			Date bohtime, String bohfile) {
		this.id = id;
		this.bohsupid = bohsupid;
		this.bohshmfid = bohshmfid;
		this.bohdhrq = bohdhrq;
		this.bohjhrq = bohjhrq;
		this.bohshtime = bohshtime;
		this.bohqxtime = bohqxtime;
		this.bohhtno = bohhtno;
		this.bohrkdd = bohrkdd;
		this.bohjyfs = bohjyfs;
		this.bohgz = bohgz;
		this.bohmemo = bohmemo;
		this.temp1 = temp1;
		this.temp2 = temp2;
		this.temp3 = temp3;
		this.temp4 = temp4;
		this.temp5 = temp5;
		this.bohtime = bohtime;
		this.bohfile = bohfile;
	}

	@EmbeddedId
	@AttributeOverrides( {
			@AttributeOverride(name = "bohsgcode", column = @Column(name = "BOHSGCODE", nullable = false, length = 30)),
			@AttributeOverride(name = "bohbillno", column = @Column(name = "BOHBILLNO", nullable = false, length = 32)),
			@AttributeOverride(name = "bohmfid", column = @Column(name = "BOHMFID", nullable = false, length = 30)) })
	public YwBorderheadId getId() {
		return this.id;
	}

	public void setId(YwBorderheadId id) {
		this.id = id;
	}

	@Column(name = "BOHSUPID", length = 30)
	public String getBohsupid() {
		return this.bohsupid;
	}

	public void setBohsupid(String bohsupid) {
		this.bohsupid = bohsupid;
	}

	@Column(name = "BOHSHMFID", length = 40)
	public String getBohshmfid() {
		return this.bohshmfid;
	}

	public void setBohshmfid(String bohshmfid) {
		this.bohshmfid = bohshmfid;
	}

	@Temporal(TemporalType.DATE)
	@Column(name = "BOHDHRQ", length = 7)
	public Date getBohdhrq() {
		return this.bohdhrq;
	}

	public void setBohdhrq(Date bohdhrq) {
		this.bohdhrq = bohdhrq;
	}

	@Temporal(TemporalType.DATE)
	@Column(name = "BOHJHRQ", length = 7)
	public Date getBohjhrq() {
		return this.bohjhrq;
	}

	public void setBohjhrq(Date bohjhrq) {
		this.bohjhrq = bohjhrq;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "BOHSHTIME")
	public Date getBohshtime() {
		return this.bohshtime;
	}

	public void setBohshtime(Date bohshtime) {
		this.bohshtime = bohshtime;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "BOHQXTIME")
	public Date getBohqxtime() {
		return this.bohqxtime;
	}

	public void setBohqxtime(Date bohqxtime) {
		this.bohqxtime = bohqxtime;
	}

	@Column(name = "BOHHTNO", length = 30)
	public String getBohhtno() {
		return this.bohhtno;
	}

	public void setBohhtno(String bohhtno) {
		this.bohhtno = bohhtno;
	}

	@Column(name = "BOHRKDD", length = 50)
	public String getBohrkdd() {
		return this.bohrkdd;
	}

	public void setBohrkdd(String bohrkdd) {
		this.bohrkdd = bohrkdd;
	}

	@Column(name = "BOHJYFS", length = 50)
	public String getBohjyfs() {
		return this.bohjyfs;
	}

	public void setBohjyfs(String bohjyfs) {
		this.bohjyfs = bohjyfs;
	}

	@Column(name = "BOHGZ", length = 300)
	public String getBohgz() {
		return this.bohgz;
	}

	public void setBohgz(String bohgz) {
		this.bohgz = bohgz;
	}

	@Column(name = "BOHMEMO", length = 50)
	public String getBohmemo() {
		return this.bohmemo;
	}

	public void setBohmemo(String bohmemo) {
		this.bohmemo = bohmemo;
	}

	@Column(name = "TEMP1", length = 30)
	public String getTemp1() {
		return this.temp1;
	}

	public void setTemp1(String temp1) {
		this.temp1 = temp1;
	}

	@Column(name = "TEMP2", length = 30)
	public String getTemp2() {
		return this.temp2;
	}

	public void setTemp2(String temp2) {
		this.temp2 = temp2;
	}

	@Column(name = "TEMP3", length = 16)
	public String getTemp3() {
		return this.temp3;
	}

	public void setTemp3(String temp3) {
		this.temp3 = temp3;
	}

	@Column(name = "TEMP4", length = 16)
	public String getTemp4() {
		return this.temp4;
	}

	public void setTemp4(String temp4) {
		this.temp4 = temp4;
	}

	@Column(name = "TEMP5", length = 16)
	public String getTemp5() {
		return this.temp5;
	}

	public void setTemp5(String temp5) {
		this.temp5 = temp5;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "BOHTIME")
	public Date getBohtime() {
		return this.bohtime;
	}

	public void setBohtime(Date bohtime) {
		this.bohtime = bohtime;
	}

	@Column(name = "BOHFILE", length = 64)
	public String getBohfile() {
		return this.bohfile;
	}

	public void setBohfile(String bohfile) {
		this.bohfile = bohfile;
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

	// 辅助字段getset开始
	@Transient
	public String getBohbillno() {
		return bohbillno;
	}

	public void setBohbillno(String bohbillno) {
		this.bohbillno = bohbillno;
	}

	@Transient
	public String getBohstatus() {
		return bohstatus;
	}

	public void setBohstatus(String bohstatus) {
		this.bohstatus = bohstatus;
	}

	@Transient
	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	@Transient
	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	@Transient
	public String getBohmfid() {
		return bohmfid;
	}

	public void setBohmfid(String bohmfid) {
		this.bohmfid = bohmfid;
	}

	@Transient
	public String getBohsgcode() {
		return bohsgcode;
	}

	public void setBohsgcode(String bohsgcode) {
		this.bohsgcode = bohsgcode;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}
	
	// 辅助字段getset结束

}
