package com.bfuture.app.saas.model;

// Generated 2011-12-7 14:38:38 by Hibernate Tools 3.2.2.GA

import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 * YwZrstockId generated by hbm2java
 */
@Embeddable
public class YwZrstockId implements java.io.Serializable {

	private String zssgcode;
	private String zssupid;
	private String zsgdid;
	private String zsmfid;
	private String zsjyfs;

	public YwZrstockId() {
	}

	public YwZrstockId(String zssgcode, String zssupid, String zsgdid,
			String zsmfid, String zsjyfs) {
		this.zssgcode = zssgcode;
		this.zssupid = zssupid;
		this.zsgdid = zsgdid;
		this.zsmfid = zsmfid;
		this.zsjyfs = zsjyfs;
	}

	@Column(name = "ZSSGCODE", nullable = false, length = 30)
	public String getZssgcode() {
		return this.zssgcode;
	}

	public void setZssgcode(String zssgcode) {
		this.zssgcode = zssgcode;
	}

	@Column(name = "ZSSUPID", nullable = false, length = 24)
	public String getZssupid() {
		return this.zssupid;
	}

	public void setZssupid(String zssupid) {
		this.zssupid = zssupid;
	}

	@Column(name = "ZSGDID", nullable = false, length = 24)
	public String getZsgdid() {
		return this.zsgdid;
	}

	public void setZsgdid(String zsgdid) {
		this.zsgdid = zsgdid;
	}

	@Column(name = "ZSMFID", nullable = false, length = 30)
	public String getZsmfid() {
		return this.zsmfid;
	}

	public void setZsmfid(String zsmfid) {
		this.zsmfid = zsmfid;
	}

	@Column(name = "ZSJYFS", nullable = false, length = 30)
	public String getZsjyfs() {
		return this.zsjyfs;
	}

	public void setZsjyfs(String zsjyfs) {
		this.zsjyfs = zsjyfs;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof YwZrstockId))
			return false;
		YwZrstockId castOther = (YwZrstockId) other;

		return ((this.getZssgcode() == castOther.getZssgcode()) || (this
				.getZssgcode() != null
				&& castOther.getZssgcode() != null && this.getZssgcode()
				.equals(castOther.getZssgcode())))
				&& ((this.getZssupid() == castOther.getZssupid()) || (this
						.getZssupid() != null
						&& castOther.getZssupid() != null && this.getZssupid()
						.equals(castOther.getZssupid())))
				&& ((this.getZsgdid() == castOther.getZsgdid()) || (this
						.getZsgdid() != null
						&& castOther.getZsgdid() != null && this.getZsgdid()
						.equals(castOther.getZsgdid())))
				&& ((this.getZsmfid() == castOther.getZsmfid()) || (this
						.getZsmfid() != null
						&& castOther.getZsmfid() != null && this.getZsmfid()
						.equals(castOther.getZsmfid())))
				&& ((this.getZsjyfs() == castOther.getZsjyfs()) || (this
						.getZsjyfs() != null
						&& castOther.getZsjyfs() != null && this.getZsjyfs()
						.equals(castOther.getZsjyfs())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result
				+ (getZssgcode() == null ? 0 : this.getZssgcode().hashCode());
		result = 37 * result
				+ (getZssupid() == null ? 0 : this.getZssupid().hashCode());
		result = 37 * result
				+ (getZsgdid() == null ? 0 : this.getZsgdid().hashCode());
		result = 37 * result
				+ (getZsmfid() == null ? 0 : this.getZsmfid().hashCode());
		result = 37 * result
				+ (getZsjyfs() == null ? 0 : this.getZsjyfs().hashCode());
		return result;
	}

}