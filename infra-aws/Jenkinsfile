pipeline {
    agent any
    environment {
        TARGET_BRANCH = 'main'
    }
    stages {
        stage('Lint Commit Messages') {
            steps {
                script {
                    // Using withCredentials to securely provide GitHub credentials
                    withCredentials([usernamePassword(credentialsId: 'github-pat', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
                        // Correctly setting up Git to use credentials
                        sh 'git config credential.helper "!f() { echo username=\\$GIT_USERNAME; echo password=\\$GIT_PASSWORD; }; f"'
                        // Fetching the target branch to compare differences
                        sh "git fetch --no-tags origin +refs/heads/${env.TARGET_BRANCH}:refs/remotes/origin/${env.TARGET_BRANCH}"

                        // Checkout to the latest commit of the PR branch
                        sh "git checkout -B ${env.BRANCH_NAME} origin/${env.BRANCH_NAME}"
                        // Extracting only the last commit message from the PR branch
                        def lastCommitMsg = sh(script: "git log -1 --pretty=format:'%s'", returnStdout: true).trim()
                        // Check the last commit message against the Conventional Commits format
                        if (!lastCommitMsg.matches("^(feat|fix|docs|style|refactor|perf|test|chore|revert|ci|build)(!)?(\\(\\S+\\))?\\: .+")) {
                            echo "The last commit message does not follow Conventional Commits format:"
                            echo " - ${lastCommitMsg}"
                            error "The last commit message is not in the Conventional Commits format. PR cannot be merged."
                        }
                    }
                }
            }
        }
        stage('Terraform Format Check') {
            steps {
                script {
                    // Check if there are any Terraform files to validate
                    def terraformFiles = sh(script: "find . -name '*.tf'", returnStdout: true).trim()
                    if (terraformFiles) {
                        // Check the formatting of Terraform files
                        def fmtOutput = sh(script: "terraform fmt -check -recursive", returnStdout: true, returnStatus: false).trim()
                        if (fmtOutput) {
                            echo "The following Terraform files are not properly formatted:"
                            echo fmtOutput
                            error "Please format your Terraform files with 'terraform fmt'."
                        } else {
                            echo "All Terraform files are properly formatted."
                        }
                    } else {
                        echo "No Terraform files found to format."
                    }
                }
            }
        }
        stage('Terraform Validate') {
            steps {
                script {
                    // Check if there are any Terraform files to validate
                    def terraformFiles = sh(script: "find . -name '*.tf'", returnStdout: true).trim()
                    if (terraformFiles) {
                        // Initialize Terraform (required before validation)
                        sh "terraform init -backend=false"
                        // Validate the Terraform files
                        sh "terraform validate"
                    } else {
                        echo "No Terraform files found to validate."
                    }
                }
            }
        }
    }
    post {
        success {
            echo 'All checks passed successfully.'
        }
        failure {
            echo 'Validation failed. Please check the logs for details.'
        }
    }
}
