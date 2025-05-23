name := "day5"

version := "0.1"

scalaVersion := "3.3.6"

scalacOptions += "@.scalacOptions.txt"

libraryDependencies ++= Seq(
  "org.scalatest" %% "scalatest"  % "3.2.19"  % Test,
  "org.scalatestplus" %% "scalacheck-1-17" % "3.2.18.0" % "test"
)

logBuffered := false

Test / parallelExecution := false

enablePlugins(JavaAppPackaging)
