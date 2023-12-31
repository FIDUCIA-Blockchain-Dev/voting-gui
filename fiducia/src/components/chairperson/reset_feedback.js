import React, { Component } from 'react';
import Web3 from 'web3';
import ChairFeedbackNav from './chairperson_FeedbackNavbar'
import {ABI,address} from '../config_feedback.js';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      account: '',
     
      
      
    };
  }

  componentDidMount() {
    this.loadBlockchainData();
  }

  async loadBlockchainData() {
    try {
      // Check if Web3 provider is available from Metamask or similar extension
      if (window.ethereum) {
        const web3 = new Web3(window.ethereum);
        await window.ethereum.enable(); // Request user permission to connect
        const accounts = await web3.eth.getAccounts();
        this.setState({ account: accounts[0] });
        const scontract = new web3.eth.Contract(ABI,address);
        this.setState({scontract});
        
      } else {
        console.log('Please install MetaMask or use a compatible browser extension.');
      }
    } catch (error) {
      console.error('Error loading blockchain data:', error);
    }
  }

 async reset() {
  const {scontract,account} = this.state;
  await scontract.methods.reset().send({from:account});
 // await scontract.methods.set_isReset(true).send({from:account});
  console.log("no of questions:"+await scontract.methods.no_of_q().call());
 }
 
  render() {
    
    
    return (
      <ChairFeedbackNav>
      <>

   
   <br/>
   <div class="d-grid gap-2 col-3 mx-5 ">
        <button class="btn border-black border-2 rounded-pill btn-lg btn-outline-dark" onClick={()=>this.reset()} type="button">Reset</button> </div>
  
    </>
    </ChairFeedbackNav>
    );
  }
}

export default App;