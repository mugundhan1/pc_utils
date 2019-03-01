/*
Counts the photons independently in 4 channels.
Coincidence check added. Can decode all 16 combinations.
Saves time differences in a text file, which can be used to plot histograms
histograms plotted using python as it is way more easy and hassle free :P

g++ -ggdb -O0 phot_det_tcpdump.cc -o phot_det_tcpdump -std=c++11

*/

#include <iostream>
#include <cstdint>
#include <fstream>
#include <sys/stat.h>
#include <string>
#include <vector>
#include <numeric>
#include <algorithm>
#include <array>

using namespace std;

struct stat results;

int main(int argc, char *argv[])
{
 ifstream f; 
 ios_base::iostate exceptionMask=f.exceptions() | ios::failbit;	
 f.exceptions(exceptionMask);

 uint32_t sof_curr=0;
 uint32_t sof_prev=0;
 int i=0;
 int k=0,l=0,m=0,n=0;
 uint8_t byte_read=0;
 uint8_t temp=0;
 double tick=0;
 double clks=1/(250e6); 
 double cnt_res=8*clks;
 vector <double> ts1,ts2,ts3,ts4,ts12,ts13,ts14,ts23,ts24,ts34,ts123,ts124,ts134,ts234,ts1234;
 
 //cout<<clks/1e-9<<"\n";
 if (argc!=2)
	cout<<"usage:\t"<<argv[0]<<" <pcap filename> \n";

 if ((stat(argv[1],&results)==0))
 	{
		cout<<"File "<<argv[1]<<" of Size "<<results.st_size<<" Found !\n";	
	}
 else
	{cout<<"File not found!\n";
	 exit(0); 	
	}
 
 try{
	f.open(argv[1],ios::in|ios::binary);
    }
 catch (ios_base::failure &e){
       cerr<<e.what()<<'\n';		
}
 if(!f.is_open())
	{
	cout<<"File not opened! \n";
	exit(0);	
	}
	
  /*
 For reading gulp type files !
  */
 f.seekg(24,f.beg);
 
 while (f.peek()!=EOF)
	{sof_prev=sof_curr;
	f.seekg(58,f.cur);
     	//f.seekg(58,f.cur);	 
	f.read(reinterpret_cast<char *>(&sof_curr),sizeof(sof_curr));
	 //cout<<sof_curr<<'\n';
  	 if (((sof_curr-sof_prev)>1) && (i!= 0))
		cout<<"Packet Number "<<i<<" lost !!!\n";	
	 
	f.seekg(4,f.cur); //not reading the end of frame counts !
	for (int j=0;j<1024;j++) //loop checks for byte patterns!
	{
	 f.read(reinterpret_cast<char *>(&byte_read),sizeof(byte_read));
	 temp=(byte_read<<4);
	/////////////////////////////////////////////////////////////////
	// Single Channel Counts				/////////
	/////////////////////////////////////////////////////////////////	 
	 if (byte_read==240)
		{tick=tick+cnt_res;}
	 if (temp == 16)
		{ ts1.push_back(((double)(byte_read>>4))*clks+tick);
		  //k=k+1;
		}
	 if (temp == 32)
		{ ts2.push_back(((double)(byte_read>>4))*clks+tick);
		  //l=l+1;
		}
	if (temp == 64)
		{ ts3.push_back(((double)(byte_read>>4))*clks+tick);
		  //m=m+1;
		}
	
	if (temp == 128)
		{ ts4.push_back(((double)(byte_read>>4))*clks+tick);
		  //if (ts4.back()==1)
		  //cout<<"Tick"<<tick<<"\n";			  
		//n=n+1;
		}
	///////////////////////////////////////////////////////////////
	// End of single channel counting			///////
	///////////////////////////////////////////////////////////////
	
	///////////////////////////////////////////////////////////////	
	// Two channel counts 					///////
	///////////////////////////////////////////////////////////////
	
	if (temp == 48)
		{ ts12.push_back(((double)(byte_read>>4))*clks+tick);
		  //k=k+1;
		}
	 if (temp == 80)
		{ ts13.push_back(((double)(byte_read>>4))*clks+tick);
		  //l=l+1;
		}
	if (temp == 96)
		{ ts23.push_back(((double)(byte_read>>4))*clks+tick);
		  //m=m+1;
		}
	
	if (temp == 144)
		{ ts14.push_back(((double)(byte_read>>4))*clks+tick);
		  //n=n+1;
		}
	
	if (temp == 160)
		{ ts24.push_back(((double)(byte_read>>4))*clks+tick);
		  //m=m+1;
		}
	
	if (temp == 192)
		{ ts34.push_back(((double)(byte_read>>4))*clks+tick);
		  //n=n+1
		}
	
	/////////////////////////////////////////////////////////////
	// End of two channel counts				/////
	/////////////////////////////////////////////////////////////
	
	/////////////////////////////////////////////////////////////
	// Three channel counts				/////
	/////////////////////////////////////////////////////////////
	
	if (temp == 112)
		{ ts123.push_back(((double)(byte_read>>4))*clks+tick);
		  //k=k+1;
		}
	 if (temp == 176)
		{ ts124.push_back(((double)(byte_read>>4))*clks+tick);
		  //l=l+1;
		}
	if (temp == 208)
		{ ts134.push_back(((double)(byte_read>>4))*clks+tick);
		  //m=m+1;
		}
	
	if (temp == 224)
		{ ts234.push_back(((double)(byte_read>>4))*clks+tick);
		  //n=n+1;
		}
	/////////////////////////////////////////////////////////////
	// End of Three channel counts				/////
	/////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////
	// Four Channel counts					/////
	/////////////////////////////////////////////////////////////	
	if (temp == 240 )
		{ ts1234.push_back(((double)(byte_read>>4))*clks+tick);
		  //n=n+1;
		}	
	/////////////////////////////////////////////////////////////
	// End of Four channel counts				/////
	/////////////////////////////////////////////////////////////
	
	}		
	i++;
	}
  
  cout<<"Time Elapsed:" << tick<<"\n";
  if (ts1.size()!=0)
  {	cout<<"size of vector 1:"<<ts1.size()<<"\n";	
	double diffts1[ts1.size()-1];
	ofstream ch1;
	ch1.open("ch1_diff.txt");  	
	adjacent_difference(ts1.begin(),ts1.end(),diffts1);
	//cout<<"size of time difference vector: "<<sizeof(diffts1)/sizeof(float)<<"\n";
  	//auto result=minmax_element(diffts1,diffts1+(ts1.size()-1));
	//cout<<"Minimum: "<<*result.first<<"Maximum: "<<*result.second<<"\n";
	for (int i=0;i<ts1.size()-1;i++)
	{	ch1<<diffts1[i]<<"\n";
	}
	ch1.close();
  }
  if (ts2.size()!=0)
  {	cout<<"size of vector 2:"<<ts2.size()<<"\n";	
	double diffts2[ts2.size()-1];
	ofstream ch2;
	ch2.open("ch2_diff.txt");
  	adjacent_difference(ts2.begin(),ts2.end(),diffts2);
 //       cout<<"size of time difference vector: "<<sizeof(diffts2)/sizeof(float)<<"\n";
//	auto result=minmax_element(diffts2,diffts2+(ts2.size()-1));
//	cout<<"Minimum: "<<*result.first<<"Maximum: "<<*result.second<<"\n";
	for (int i=0;i<ts2.size()-1;i++)
	{	ch2<<diffts2[i]<<"\n";
	}  
	ch2.close();
}
  
  if (ts3.size()!=0)
  {	cout<<"size of vector 3:"<<ts3.size()<<"\n";  	
	double diffts3[ts3.size()-1];
  	adjacent_difference(ts3.begin(),ts3.end(),diffts3);
	ofstream ch3;
	ch3.open("ch3_diff.txt");        
	//cout<<"size of time difference vector: "<<sizeof(diffts3)/sizeof(float)<<"\n"; 
	//auto result=minmax_element(diffts3,diffts3+(ts3.size()-1));
	//cout<<"Minimum: "<<*result.first<<"Maximum: "<<*result.second<<"\n";
  	for (int i=0;i<ts3.size()-1;i++)
	{	ch3<<diffts3[i]<<"\n";
	}
	ch3.close();
  }
  
  if (ts4.size()!=0)
  {     cout<<"size of vector 4:"<<ts4.size()<<"\n";
	double diffts4[ts4.size()-1];
  	adjacent_difference(ts4.begin(),ts4.end(),diffts4);
	ofstream ch4;
	ch4.open("ch4_diff.txt");      
	//  cout<<"size of time difference vector: "<<sizeof(diffts4)/sizeof(float)<<"\n"; 
      //	auto result=minmax_element(diffts4,diffts4+(ts4.size()-1));
      //	cout<<"Minimum: "<<*result.first<<"Maximum: "<<*result.second<<"\n";
  	for (int i=0;i<ts4.size()-1;i++)
	{	ch4<<diffts4[i]<<"\n";
		//ch4<<ts4[i]<<"\n";	
	}
	ch4.close();
  }
if (ts12.size()!=0)
  {	cout<<"size of vector 12:"<<ts12.size()<<"\n";	
	double diffts12[ts12.size()-1];
	ofstream ch12;
	ch12.open("ch12_diff.txt");  	
	adjacent_difference(ts12.begin(),ts12.end(),diffts12);
	//cout<<"size of time difference vector: "<<sizeof(diffts1)/sizeof(float)<<"\n";
  	//auto result=minmax_element(diffts1,diffts1+(ts1.size()-1));
	//cout<<"Minimum: "<<*result.first<<"Maximum: "<<*result.second<<"\n";
	for (int i=0;i<ts1.size()-1;i++)
	{	ch12<<diffts12[i]<<"\n";
	}
	ch12.close();
  }
  if (ts13.size()!=0)
  {	cout<<"size of vector 13:"<<ts13.size()<<"\n";	
	double diffts13[ts13.size()-1];
	ofstream ch13;
	ch13.open("ch13_diff.txt");
  	adjacent_difference(ts13.begin(),ts13.end(),diffts13);
 //       cout<<"size of time difference vector: "<<sizeof(diffts2)/sizeof(float)<<"\n";
//	auto result=minmax_element(diffts2,diffts2+(ts2.size()-1));
//	cout<<"Minimum: "<<*result.first<<"Maximum: "<<*result.second<<"\n";
	for (int i=0;i<ts13.size()-1;i++)
	{	ch13<<diffts13[i]<<"\n";
	}  
	ch13.close();
}
  
  if (ts14.size()!=0)
  {	cout<<"size of vector 14:"<<ts14.size()<<"\n";  	
	double diffts14[ts14.size()-1];
  	adjacent_difference(ts14.begin(),ts14.end(),diffts14);
	ofstream ch14;
	ch14.open("ch14_diff.txt");        
	//cout<<"size of time difference vector: "<<sizeof(diffts3)/sizeof(float)<<"\n"; 
	//auto result=minmax_element(diffts3,diffts3+(ts3.size()-1));
	//cout<<"Minimum: "<<*result.first<<"Maximum: "<<*result.second<<"\n";
  	for (int i=0;i<ts14.size()-1;i++)
	{	ch14<<diffts14[i]<<"\n";
	}
	ch14.close();
  }
  
  if (ts23.size()!=0)
  {     cout<<"size of vector 23:"<<ts23.size()<<"\n";
	double diffts23[ts23.size()-1];
  	adjacent_difference(ts23.begin(),ts23.end(),diffts23);
	ofstream ch23;
	ch23.open("ch23_diff.txt");      
	//  cout<<"size of time difference vector: "<<sizeof(diffts4)/sizeof(float)<<"\n"; 
      //	auto result=minmax_element(diffts4,diffts4+(ts4.size()-1));
      //	cout<<"Minimum: "<<*result.first<<"Maximum: "<<*result.second<<"\n";
  	for (int i=0;i<ts23.size()-1;i++)
	{	ch23<<diffts23[i]<<"\n";
	}
	ch23.close();
  }	

  if (ts24.size()!=0)
  {	cout<<"size of vector 24:"<<ts24.size()<<"\n";  	
	double diffts24[ts24.size()-1];
  	adjacent_difference(ts24.begin(),ts24.end(),diffts24);
	ofstream ch24;
	ch24.open("ch24_diff.txt");        
	//cout<<"size of time difference vector: "<<sizeof(diffts3)/sizeof(float)<<"\n"; 
	//auto result=minmax_element(diffts3,diffts3+(ts3.size()-1));
	//cout<<"Minimum: "<<*result.first<<"Maximum: "<<*result.second<<"\n";
  	for (int i=0;i<ts24.size()-1;i++)
	{	ch24<<diffts24[i]<<"\n";
	}
	ch24.close();
  }
  
  if (ts34.size()!=0)
  {     cout<<"size of vector 34:"<<ts34.size()<<"\n";
	double diffts34[ts34.size()-1];
  	adjacent_difference(ts34.begin(),ts34.end(),diffts34);
	ofstream ch34;
	ch34.open("ch34_diff.txt");      
	//  cout<<"size of time difference vector: "<<sizeof(diffts4)/sizeof(float)<<"\n"; 
      //	auto result=minmax_element(diffts4,diffts4+(ts4.size()-1));
      //	cout<<"Minimum: "<<*result.first<<"Maximum: "<<*result.second<<"\n";
  	for (int i=0;i<ts34.size()-1;i++)
	{	ch34<<diffts34[i]<<"\n";
	}
	ch34.close();
  }	
  
    if (ts123.size()!=0)
  {     cout<<"size of vector 123:"<<ts123.size()<<"\n";
	double diffts123[ts123.size()-1];
  	adjacent_difference(ts123.begin(),ts123.end(),diffts123);
	ofstream ch123;
	ch123.open("ch123_diff.txt");      
	//  cout<<"size of time difference vector: "<<sizeof(diffts4)/sizeof(float)<<"\n"; 
      //	auto result=minmax_element(diffts4,diffts4+(ts4.size()-1));
      //	cout<<"Minimum: "<<*result.first<<"Maximum: "<<*result.second<<"\n";
  	for (int i=0;i<ts123.size()-1;i++)
	{	ch123<<diffts123[i]<<"\n";
	}
	ch123.close();
  }	
   if (ts134.size()!=0)
  {     cout<<"size of vector 134:"<<ts134.size()<<"\n";
	double diffts134[ts134.size()-1];
  	adjacent_difference(ts134.begin(),ts134.end(),diffts134);
	ofstream ch134;
	ch134.open("ch134_diff.txt");      
	//  cout<<"size of time difference vector: "<<sizeof(diffts4)/sizeof(float)<<"\n"; 
      //	auto result=minmax_element(diffts4,diffts4+(ts4.size()-1));
      //	cout<<"Minimum: "<<*result.first<<"Maximum: "<<*result.second<<"\n";
  	for (int i=0;i<ts134.size()-1;i++)
	{	ch134<<diffts134[i]<<"\n";
	}
	ch134.close();
  }	 
 
  if (ts124.size()!=0)
  {     cout<<"size of vector 124:"<<ts124.size()<<"\n";
	double diffts124[ts124.size()-1];
  	adjacent_difference(ts124.begin(),ts124.end(),diffts124);
	ofstream ch124;
	ch124.open("ch124_diff.txt");      
	//  cout<<"size of time difference vector: "<<sizeof(diffts4)/sizeof(float)<<"\n"; 
      //	auto result=minmax_element(diffts4,diffts4+(ts4.size()-1));
      //	cout<<"Minimum: "<<*result.first<<"Maximum: "<<*result.second<<"\n";
  	for (int i=0;i<ts124.size()-1;i++)
	{	ch124<<diffts124[i]<<"\n";
	}
	ch124.close();
  }

  if (ts234.size()!=0)
  {     cout<<"size of vector 234:"<<ts234.size()<<"\n";
	double diffts234[ts234.size()-1];
  	adjacent_difference(ts234.begin(),ts234.end(),diffts234);
	ofstream ch234;
	ch234.open("ch234_diff.txt");      
	//  cout<<"size of time difference vector: "<<sizeof(diffts4)/sizeof(float)<<"\n"; 
      //	auto result=minmax_element(diffts4,diffts4+(ts4.size()-1));
      //	cout<<"Minimum: "<<*result.first<<"Maximum: "<<*result.second<<"\n";
  	for (int i=0;i<ts234.size()-1;i++)
	{	ch234<<diffts234[i]<<"\n";
	}
	ch234.close();
  }
	
    if (ts1234.size()!=0)
  {     cout<<"size of vector 1234:"<<ts1234.size()<<"\n";
	double diffts1234[ts1234.size()-1];
  	adjacent_difference(ts1234.begin(),ts1234.end(),diffts1234);
	ofstream ch1234;
	ch1234.open("ch1234_diff.txt");      
	//  cout<<"size of time difference vector: "<<sizeof(diffts4)/sizeof(float)<<"\n"; 
      //	auto result=minmax_element(diffts4,diffts4+(ts4.size()-1));
      //	cout<<"Minimum: "<<*result.first<<"Maximum: "<<*result.second<<"\n";
  	for (int i=0;i<ts1234.size()-1;i++)
	{	ch1234<<diffts1234[i]<<"\n";
	}
	ch1234.close();
  }		
  f.close();		
  cout<<"Closed file \n";
  cout<<"Loop ran for "<<i<<" times\n";
 return 0;
}
