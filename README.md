BatchSubmit is a lightweight open source Distributed Asynchronous Job Submitting/Scheduling Platform, a true Task as Service solution<p>

It rethinks software not as applications, but as executable tasks — invoked directly, parameterized, which creates it own UI on the fly.

Seeking strategic partners for scaling (VC inquiries welcome).<p>

Our mission:<p>

To liberate program execution from the hands of programmers, and turn it into a empowering tool for ordinary users.<p>


Core Value Proposition

Traditional program execution environments are developer-centric. They require users to understand programming languages, command lines, or configuration scripts in order to run or modify computational tasks. This paradigm has long limited the accessibility and reusability of complex software systems.

The platform introduces a new model that fully separates program logic from the user interface. Through the Parameter-as-File (PAF) mechanism, the program’s inputs, options, and execution context are exposed in a structured file format. End users can configure and execute programs through a graphical or form-based interface—without ever interacting with source code.

At its core, this mechanism represents an abstraction of program complexity. It allows professional developers to focus on algorithms and logic, while enabling non-technical users to control and apply these capabilities in an intuitive, semantic way. This layered architecture effectively dissolves the boundary between “programmer” and “user,” bringing advanced computational functions into everyday workflows.

From a platform perspective, this is more than a technical convenience—it is a paradigm shift in computational interaction. It transforms executable knowledge from a developer’s toolbox into a broadly accessible operational resource.

Although the implementation of the Parameter-as-File model is remarkably simple — essentially a structured parameter file rendered into a user-facing interface — the conceptual implications are profound.
It redefines how programs are executed, parameterized, and shared, shifting computational control from programmers to end users.

The real value of a platform doesn’t come from the cloud itself — it comes from the applications that users can directly use.<p>
This platform makes it easy for developers to build small, ready-to-run cloud environments that end users can immediately use without technical knowledge.<p>
Each application is defined by a simple parameter file — once uploaded, it becomes a live, interactive tool on the web.<p>
In short, this is not just another cloud platform — it’s a platform for instantly usable applications.<p>

main entrance: main2.cgi

admin username/password: admin/bs2018

System Requirements: 

OS: Windows or Linux<br>
Web server: Apache<br>
Scripting language: Perl 5<br>
Software Packages: SAS(optional), R, Python<br>

a little tip: install Apache sever on: "C:\Apache" directory if you are running Windows OS.

With BatchSubmit.com, you can:<p>

obtain similar functionalities as AWS Batch/AWS Step Functions, Google Cloud Workflows/Cloud Tasks, Azure batch, IBM Cloud Schematics/DataStage<p>
run programs that take hours, even days to complete, loss of connection won't affect the execution.<p>
submit multiple programs at once, they will run sequentially.<p>
easily build a web interface for user input and memorize it, integrate with other web tools.<p>
have unified development/test/production environment, enable collaboration among coworkers.<p>
access remote data via web services.<p>
take advantage of fully integrated file management system.<p>
access library of sample code and public data.<p>
run programs from mobile devices, anywhere.<p>
schedule cron jobs.<p>
although it is designed to run SAS/R/Python, it can be easily modified to run any command line based programs, such as Oracle Sqlplus Scripts or SQL server scripts, even Fortran and Cobol, and many more ...<p>

this project is fully functional in Perl CGI, I am looking for contributors who can help port it to Python: <a href="https://github.com/socaltiger/BatchSubmit.com-Python">BatchSubmit.com-Python</a><p>

If you installed a copy of the platform on the web, could you please share the URL with me? I am compiling a list of installed bases.

 ⭐ If you find this project interesting, please consider giving it a star!

This is an open-source platform designed to make running complex programs simple for end users.  
The core technology works — now the next step is helping more people see its value.  

If you’re interested in joining as a collaborator (UX, documentation, community, or outreach),  
please reach out via GitHub Issues or email: omnitiger@gmail.com .
