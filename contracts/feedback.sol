pragma solidity ^0.8.17;
// SPDX-License-Identifier: GPL-3.0
contract feedback {
    address public chairperson;
    struct questions
    {
        string questions;
        string type_of_ans;
    }
    questions[] public Questions;
    struct questions_and_answers
    {
        uint question;
        string answer;
    }
    questions_and_answers[] public Questions_And_Answers;
    struct User
    {
        address user_address;
        
        bool registered;
    }
    struct answers_with_question
    {
        uint  question_no;
        string[4] answers;
        
    }
    answers_with_question[] public Answers_with_Question;
    bool public start = false;
    address[] registered_users;
    mapping(address=>User) public users;
    bool isReset = false;
    constructor() {
        chairperson = msg.sender;
    }

    function Start() public {
        //require(!start, "already started");
        start = true;
    }
    function set_isReset(bool a) public {
        isReset = a;
    }
    function get_isReset() public view returns (bool) {
        return isReset;
    }
    function no_of_q() public view returns (uint){
        return Questions.length;
    }
    function questions_input(string[] calldata question,uint no_of_qu,string[] memory ty) public {
        require(start, "Question input is not allowed before starting.");
        require(msg.sender==chairperson,"only chairperson is allowed to input question");
        require(question.length==no_of_qu,"no of questions should be equal to mentioned");
        for(uint i=0;i<no_of_qu;i++)
        {
            Questions.push(questions({
                questions:question[i],
                type_of_ans:ty[i]
            }));
        }
        
    }
   // Define a mapping to store answers for each question
mapping(uint => answers_with_question) public AnswersMap;
 uint[] public keys; // This array will store the keys
function answers_input(uint q_no, string[4] memory answer) public {
    require(start, "Question input is not allowed before starting.");
    require(msg.sender == chairperson, "only chairperson is allowed to input options");
    require(q_no >= 0 && q_no < Questions.length, "Invalid question number");

    // Store answers using the mapping
    AnswersMap[q_no] = answers_with_question({
        question_no: q_no,
        answers: answer
       
    });
     keys.push(q_no); // Add the key to the keys array
}
    function register() public 
    {     
          address person = msg.sender;
          require(start, "cannot register before starting");
        require(msg.sender!=chairperson,"chairperson cannot register");
        require(users[person].registered==false,"user is already registered");
      
        users[person].user_address = person;
        users[person].registered = true;
        registered_users.push(person);

    }
    function answers(uint question_no,string calldata answer1) public {
        require(question_no >= 0 && question_no < Questions.length, "Invalid question number");
         address person = msg.sender;
         require(users[person].registered==true,"user is not registered");
         require(start, "cannot answer before starting");
         Questions_And_Answers.push(questions_and_answers({
             question:question_no,
             answer:answer1
         }));
    }
  function getAnswersForQuestion(uint question_no) public view returns (string[] memory) {
    require(question_no >= 0 && question_no < Questions.length, "Invalid question number");
    require(msg.sender == chairperson, "The user is not a chairperson");
    require(start, "Cannot get answers before starting");

    string[] memory answer = new string[](Questions_And_Answers.length); // Initialize an array with a fixed length

    uint k = 0;
    for (uint i = 0; i < Questions_And_Answers.length; i++) {
        if (Questions_And_Answers[i].question == question_no) {
            answer[k] = Questions_And_Answers[i].answer;
            k++;
        }
    }

    // Resize the array to the correct length
    assembly {
        mstore(answer, k)
    }

    return answer;
}
function get_Questions(uint q_no) public view returns(string memory) {
     require(q_no >= 0 && q_no < Questions.length, "Invalid question number");
    return Questions[q_no].questions;
}

function get_options(uint q_no) public view returns (string[4] memory){
    require(q_no >= 0 && q_no < Questions.length, "Invalid question number");
    
   return AnswersMap[q_no].answers;
}
function get_type(uint q_no) public view returns (string memory){
    return Questions[q_no].type_of_ans;

}

function reset() public 
{   require(msg.sender==chairperson,"the user is not chairperson");
    start = false;
    isReset = true;
    //Questions_And_Answers
    //users
    //Questions
   /* for(uint i=0;i<Questions_And_Answers.length;i++)
    {
        delete Questions_And_Answers[i];
    }*/
    while(Questions_And_Answers.length>0)
    {
        Questions_And_Answers.pop();
    }
    
    for(uint i=0;i<registered_users.length;i++)
    {
        delete users[registered_users[i]];
    }
    /*for(uint i=0;i<Questions.length;i++)
    {
        delete Questions[i];
    }*/
    while(Questions.length>0)
    {
        Questions.pop();
    }
    
    /*for(uint i=0;i<Answers_with_Question.length;i++)
    {
        delete Answers_with_Question[i];
    }*/
    while(Answers_with_Question.length>0)
    {
        Answers_with_Question.pop();
    }
   
     // Iterate through the keys and delete the values
        for (uint i = 0; i < keys.length; i++) {
            delete AnswersMap[keys[i]];
        }
        // Clear the keys array
        //delete keys;
        while(keys.length>0)
        {
            keys.pop();
        }
        
}

}