+++
title =  "If Your Monolith Sucks, Your Microservices Won't Be Any Better"
tags = ["software design"]
date = "2023-12-29"
draft = false
+++

> Alternatively: don't weld a dozen smart cars together to do a race car's job.

I recently had a conversation with an ops friend about the trend of using microservices for everything and decided our conversation could be reworked into a good post. If you don't have time to read this entire post, the general conclusion is that using microservices will not save you from the consequences of choosing the wrong tools for the job at hand or being a bad programmer.

Microservices for the sake of microservices is really not all what it's cracked up to be. We were promised smaller, interconnected projects with better scalability and lower cognitive complexity allowing for easier maintainability. What we got instead was Kubernetes, ever-increasing AWS bills with services like Lambda and EKS, and further apologetics for the use of JavaScript on the backend for higher and higher demand applications where JavaScript is increasingly out of place. This isn't to say microservice architectures don't have their strengths. After all, even if I have criticism it's not like FAANG companies developed them for no reason. If enough people are accessing a small part of your overall service, it totally makes sense to break it out into a smaller "microservice" so those people aren't slowing down the broader scope. There is, however, a nuance.

The main selling point of Kubernetes and other container orchestration schemes is promising developers they won't have to think too hard. You just write your service and stick it in a container. If your code fails in production, Kubernetes will just restart it for you so there's no need to handle errors well. If your code gets too bogged down with requests, Kubernetes will just autoscale the deployment for you. If you need more nodes, plenty of developers are perfectly content to imagine those will just autoscale too. Removing the requirement of familiarity with how computers work and the systems your code will run on has dramatically reduced the skill requirements for being considered a software engineer. These days if a company wants to reduce their spending on developer talent they can hire frontend developers, give them Node, and have then write heavily abstracted "microservices" that aren't too complex or difficult and call them full stack developers.

At an industrial scale, this mindset manifests as services like AWS Lambda. With an entire datacenter of capacity on tap, developers don't have to think about scaling at all. You don't need to think about deployment cycles, downstream request handling, proxy configuration, or anything like that. AWS Lambda is the ultimate optimization for deskilled developers and they'll happily run your code no matter how inefficient for 1000% more than it should ever cost anyone to run.

When you create a new function in AWS Lambda, it's assumed you'll be using JavaScript to do it. It's what their editors default to. Treating a slow, single threaded, interpreted language like JavaScript (or even worse, Python) as a default also means treating the overhead and wasted hardware capacity implied by using those tools as default. When that lost potential is assumed, the threshold for when a service can't keep up with demand anymore gets a lot lower. When the threshold gets lower, systems like Kubernetes get introduced a lot sooner. Messaging-heavy architectures are planned from the start because people know subconsciously that the language and tools they're building this service in won't be able to keep up with demand. Then, when things fail, tracing has to dive into all the abstraction layers Kubernetes has put in place. Everything becomes far more complex with far more points of failure because extra abstraction layers and complexity were added instead of using better tools to reduce the baseline lost potential.

Nowhere is this more glaring than charts like this one by [@lholznagel](https://medium.com/@lholznagel/comparing-nodejs-and-rust-http-frameworks-response-times-5738dfa1843d), which shows even the fastest backend JavaScript framework losing to a completely unoptimized build of the same logic in Rocket. When the Rust approach has its usual optimizations turned on, the JavaScript frameworks aren't even in the same order of magnitude of performance anymore.

![Chart](/images/rocketexpress.webp)

This chart by [Ferdinand Mütsch](https://muetsch.io/http-performance-java-jersey-vs-go-vs-nodejs.html) also paints a pretty damning picture for JavaScript backends, this time using Go and Java.

![Chart](/images/goexpress.svg)

All of this is to say if you picked the wrong tools from the start and built your monolith poorly, microservices won't save you. Any gains you get from using messaging-heavy microservices architectures can typically be dwarfed by the gains from using a language that isn't Node, Python, or Ruby on Rails. Stop accepting worse performance from your tools just because there's some hot trend to make up for it. At a certain level, there is no technical solution to the problem of our field being de-skilled. You just have to get stronger skills, write better code, solve harder challenges, and stop expecting ops to put in lots of upfront work to coddle you.
