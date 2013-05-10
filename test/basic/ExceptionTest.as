package basic
{
	public class ExceptionTest
	{		
		[Test(expected="Error")]
		public function testException():void{
			
			try{
				throw(new Error("abc"));	
			}
			catch(e:Error){
				throw(new Error("abc"));	
			}
			
			
			
			
		}
	}
}