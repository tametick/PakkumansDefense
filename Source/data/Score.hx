package data;

class Score {
	public var level:Int;
	public var money:Int;
	public var kills:Int;
	public var towers:Int;
	
	public function new(level:Int, money:Int, kills:Int, towers:Int) {
		this.level = level;
		this.money = money;
		this.kills = kills;
		this.towers = towers;
	}
}