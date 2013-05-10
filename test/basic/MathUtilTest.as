package basic
{
	import org.flexunit.Assert;

	public class MathUtilTest
	{		
		[Test]
		public function testAdd():void{
			Assert.assertEquals(3, MathUtil.add(1, 2));
		}
	}
}