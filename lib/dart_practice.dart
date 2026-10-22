
// void main() {
//   String task = "Build to do app";
//   int totalTasks = 5;
//   double progress = 0.5;
//   bool isCompleted = true;

//   print(task);
//   print(totalTasks);
//   print(progress);
//   print(isCompleted);
// }

// String checkStatus(bool isCompleted){
//   if(isCompleted== true){
//     return "task completed";
//   }
//   else{
//   return "task pending";
//   }
// }

// void main(){
//   print(checkStatus(true));
// }

// int getDiscount(int price){
//   if(price >=1000){
//     return (price -100);
//   }
//   else {
//     return price;
//   }
// }

// void main(){
//   print(getDiscount(800));
// }

// int calculateTotal(int price, int quantity){
//   int total = price *quantity ;
//   if( total>= 500){
//     return  total;
  
//   }
//   else{
//     return (total+50);
//   }
// }

// void main(){
//   print(calculateTotal(200,3));
// }

// String getTaskMesssage(bool isCompleted){
//   if(isCompleted == true){
//     return "greate job";
  
//   }
//   else{
//     return "keep going";
//   }
// }

// void main(){
//   print(getTaskMesssage(true));
//     print(getTaskMesssage(false));

// }


// void main(){
//   List<String>tasks=[
//     "learn dart",
//     "learn flutter",
//     "build todo app"
//   ];

//   for ( String task in tasks){
//   print(task);
//   }
// }

// void main(){
//   List<String> tasks = ["study","build","test"];

//   for ( String task in tasks){
//     if ( task =="build"){
//       print("Building the app");
//     }
//     else{
//       print(task);
//     }
//   }
// }

// void  main(){
//   List<String>tasks = [
//     "Learn Dart","Practice Flutter","Build App"
    
//   ];
//   for ( String task in tasks){
//     print(task);
//   }
// }

// void main(){
//   Map<String, dynamic>tasks={
//     "title" : "learn dart",
//     "isCompleted" : false,
//     "priority":1

//       };
//       print(tasks["title"]);
//             print(tasks["isCompleted"]);
            
// }

void main(){
  Set<String> tasks = {"Study", "build"};

   tasks.add("test");
   tasks.remove("study");

   print(tasks.contains("study"));
   print(tasks.length);

}



// class Task {
//   String title;

//   Task(this.title);

//   String getTitle() {
//     print(title);
//     return title;
//   }
// }

// void main() {
//   Task task1 = Task("Learn Dart");

//   String result = task1.getTitle();

//   print(result);
// }

// class Task{
//   String title ;

//   Task(this.title);
// }

// void main(){
//   List<Task>tasks = [
//        Task("learn dart"),
//        Task("learn flutter"),
//        Task("Build to do app"),
//   ];

//   print(tasks.length);
//   print(tasks[0].title);

// }